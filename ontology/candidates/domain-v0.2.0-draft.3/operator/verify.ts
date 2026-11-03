import { trigger, type Actor, type ActionRelationship, type Entity } from "./generated/relations";
import { ActionRelationshipRecordSchema } from "./generated/validators";
import type { AddRepository, Project, Repository, User } from "./generated/types";

function requireThat(condition: boolean, message: string): void {
  if (!condition) throw new Error(message);
}

async function exercise() {
  const p = { $type: "gitview:Project", id: "p" } satisfies Project;
  const q = { $type: "gitview:Project", id: "q" } satisfies Project;
  const r1 = { $type: "gitview:Repository", id: "r1" } satisfies Repository;
  const r2 = { $type: "gitview:Repository", id: "r2" } satisfies Repository;
  const repositories = new Map([r1, r2].map(r => [r.id, r] as const));
  const members = new Map<string, Set<Repository>>([[p.id, new Set([r1])], [q.id, new Set([r2])]]);
  const calls: { subject: User; object: Project }[] = [];

  const user = {
    $type: "gitview:User", id: "operator-1",
    run(action, project) {
      const repo = repositories.get(action.repositoryId);
      const projectMembers = members.get(project.id);
      if (!repo || !projectMembers) throw new Error("Unresolved local reference");
      projectMembers.add(repo);
      calls.push({ subject: this, object: project });
    },
  } satisfies User & Actor<AddRepository, Project & Entity>;

  const relationship = {
    relation: "gitview:addsRepositoryTo",
    subject: user,
    action: { $type: "gitview:AddRepository", repositoryId: r2.id },
    object: p,
  } satisfies ActionRelationship<"gitview:addsRepositoryTo">;

  const record = ActionRelationshipRecordSchema.parse(JSON.parse(JSON.stringify(relationship)));
  const membersOf = (projectId: string) => [...(members.get(projectId) ?? [])].map(r => r.id);
  const before = { p: membersOf("p"), q: membersOf("q") };
  requireThat(record.subject.id === user.id && record.object.id === p.id && !("run" in record.subject),
              "Expected an identified operator and a data-only record");
  requireThat(before.p.join() === "r1" && before.q.join() === "r2" && calls.length === 0, "Reading executed an action");
  await trigger(relationship);
  const after = { p: membersOf("p"), q: membersOf("q") };
  requireThat(calls.length === 1 && calls[0]?.subject === user && calls[0]?.object === p, "Wrong actor, target or call count");
  requireThat(after.p.join() === "r1,r2" && after.q.join() === "r2" &&
    members.get(p.id)?.has(r2) === true && members.get(q.id)?.has(r2) === true, "Repository membership drifted");

  const unknown = { ...relationship, action: { ...relationship.action, repositoryId: "unknown" } };
  let rejected = false;
  try { await trigger(unknown); }
  catch (error) {
    if (!(error instanceof Error && error.message === "Unresolved local reference")) throw error;
    rejected = true;
  }
  requireThat(rejected && calls.length === 1 && membersOf(p.id).join() === "r1,r2" && membersOf(q.id).join() === "r2",
              "An unresolved reference changed the projects");
  requireThat(!ActionRelationshipRecordSchema.safeParse({ ...record, subject: { $type: "gitview:GitHub", id: user.id } }).success,
              "A source service identity was accepted as the operator");
  requireThat(!ActionRelationshipRecordSchema.safeParse({ ...record, action: { $type: "gitview:AddRepository" } }).success,
              "The action lost the repository reference");
  return { actor: user.id, project: p.id, repository: r2.id, before, after, successfulCalls: calls.length,
           unknownReferenceRejected: rejected };
}

// Compiled by the test harness. These calls must fail typechecking.
function negativeControls(record: ActionRelationship<"gitview:addsRepositoryTo">, dataOnly: User & Entity) {
  // @ts-expect-error A stored User has no declared implementation of this action.
  trigger({ ...record, subject: dataOnly });
  // @ts-expect-error A Repository cannot be substituted for the Project whose membership changes.
  trigger({ ...record, object: { $type: "gitview:Repository", id: "r2" } });
}

exercise().then(result => console.log(JSON.stringify(result)));
