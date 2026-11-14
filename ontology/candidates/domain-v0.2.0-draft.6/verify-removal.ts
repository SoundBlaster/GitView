import { classes, relations, type Ref } from "./generated/refs";
import { trigger, type Actor, type ActionRelationship, type Entity } from "./generated/relations";
import { ActionRelationshipRecordSchema } from "./generated/validators";
import type { Project, RemoveRepository, Repository, User } from "./generated/types";

function ensure(value: boolean, message: string): void { if (!value) throw new Error(message); }
const r1 = { $type: classes.Repository.alias, id: "r1" } satisfies Repository & Entity;
const r2 = { $type: classes.Repository.alias, id: "r2" } satisfies Repository & Entity;
const p = { $type: classes.Project.alias, id: "p" } satisfies Project & Entity;
const q = { $type: classes.Project.alias, id: "q" } satisfies Project & Entity;
const rows = new Map([["r1", r1], ["r2", r2]]);
const members = new Map([[p.id, new Set([r1, r2])], [q.id, new Set([r1])]]);
const user = {
  $type: classes.User.alias, id: "operator",
  run(action, object) {
    const ref = action.repository;
    const repo = typeof ref.locator === "string" ? rows.get(ref.locator) : undefined;
    const target = members.get(object.id);
    if (!repo || !target) throw new Error("unresolved");
    if (!target.has(repo)) throw new Error("not-member");
    if (target.size <= 1) throw new Error("last-member");
    target.delete(repo);
  },
} satisfies User & Actor<RemoveRepository, Project & Entity>;
function relation(project: Project & Entity, repo: Ref<Repository>) {
  return { relation: relations.removesRepositoryFrom.alias, subject: user,
    action: { $type: classes.RemoveRepository.alias, repository: repo }, object: project } as const;
}
const ref = (locator: string): Ref<Repository> => ({ target: classes.Repository.alias, locator });
const ok = relation(p, ref("r1"));
const data = ActionRelationshipRecordSchema.parse(JSON.parse(JSON.stringify(ok)));
ensure(data.relation === relations.removesRepositoryFrom.alias, "record invalid");
ensure(members.get("p")?.size === 2 && members.get("q")?.size === 1, "read changed membership");
trigger(ok);
ensure(members.get("p")?.has(r2) === true && !members.get("p")?.has(r1) && members.get("q")?.has(r1) === true, "wrong delta");
for (const [rel, reason] of [[relation(p, ref("missing")), "unresolved"], [relation(p, ref("r1")), "not-member"], [relation(p, ref("r2")), "last-member"]] as const) {
  let error = ""; try { trigger(rel); } catch (e) { error = e instanceof Error ? e.message : "unexpected"; }
  ensure(error === reason && members.get("p")?.size === 1 && members.get("q")?.has(r1) === true, reason);
}
const wrongTarget: Ref<Project> = { target: classes.Project.alias, locator: "p" };
for (const action of [{ $type: classes.RemoveRepository.alias }, { $type: classes.RemoveRepository.alias, repository: wrongTarget }]) {
  ensure(!ActionRelationshipRecordSchema.safeParse({ ...data, action }).success, "bad action accepted");
}
ensure(!ActionRelationshipRecordSchema.safeParse({ ...data, subject: { $type: classes.GitHub.alias, id: "github" } }).success,
  "source service accepted as operator");
function typeChecks(record: ActionRelationship<"gitview:removesRepositoryFrom">) {
  // @ts-expect-error Reference to Project cannot be used where Repository is required.
  const bad: RemoveRepository = { $type: classes.RemoveRepository.alias, repository: wrongTarget };
  // @ts-expect-error Repository is not the Project object.
  trigger({ ...record, object: r1 });
  // @ts-expect-error Data-only User has no action handler.
  trigger({ ...record, subject: { $type: classes.User.alias, id: "operator" } });
  return bad;
}
void typeChecks;
console.log(JSON.stringify({before:{p:["r1","r2"],q:["r1"]},after:{p:["r2"],q:["r1"]},unknownRejected:true,absentRejected:true,lastMemberRejected:true,malformedRejected:true}));
