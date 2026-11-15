# Native static preview: candidate and evidence boundary

Status: agent-authored technical exploration for the pre-canonical graph. This
is not a selected UI architecture, an implementation, or evidence of device
behavior. The first-version product behavior is defined by 0031, 0075 and
0093; the later sliding preview is outside this exploration.

## Platform evidence

Apple documents a [SwiftUI context menu with a preview](https://developer.apple.com/documentation/swiftui/view/contextmenu%28menuitems%3Apreview%3A%29).
For UIKit, [UIContextMenuInteractionDelegate](https://developer.apple.com/documentation/uikit/uicontextmenuinteractiondelegate)
provides a configuration, permits a supplied preview controller and describes a
callback when a preview action begins. Apple describes the accompanying
[commit animator](https://developer.apple.com/documentation/uikit/uicontextmenuinteractioncommitanimating)
as system-supplied. These are candidate platform building blocks, not proof
that either API satisfies the entire GitView interaction contract.

## Contract-to-platform questions

| Requirement | Candidate mapping and remaining evidence |
| --- | --- |
| Static preview for the actual object | The host can associate its configuration with a stable identity and origin, independently of reusable cell position. Verify the selected host and callback lifetime on supported OS versions. |
| Open from preview | An action-start callback can begin an app-controlled Open intent. It is not successful admission: recheck current identity, origin and disclosure before committing a route. System dismissal as part of Open is distinct from explicit cancellation. |
| Denial or changed origin during transition | The app must enforce 0031 and 0093 on app-controlled content and destination admission, including accessible content. Establish what the chosen platform presentation allows during an active transition; do not infer redaction behavior from the existence of a callback. |
| Accessible inspection | 0093 requires a discoverable way to invoke and dismiss the preview without long press. A direct Open action alone does not satisfy this. Verify the actual control and VoiceOver behavior; the listed documentation does not establish it. |
| Tap, scroll, pinch and long press | 0075 requires distinct outcomes and cancellation. Context-menu documentation alone does not establish recognizer arbitration or a continuous cross-scope pinch under 0120. Evaluate them with the chosen grid host, dense cells, accessibility and motion settings. |
| Refresh and cell reuse | Bind presentation and requests to the actual instance, source and account under 0031 and 0093. Verify native presentation lifetime and redraw behavior, including a late response after dismissal and reopening the same object. |

## Readiness

The system APIs make a native direction plausible, but do not establish an
implementation-ready platform adapter. Selection of SwiftUI or UIKit host,
deployment target, callback ordering, accessible alternative, live restriction
handling and gesture behavior remain open. Define and verify these together
before calling the relevant platform leaf implementation-ready; if a candidate
cannot preserve disclosure or identity, choose another native presentation
that can. Do not treat a future device experiment as product implementation or
as evidence obtained already.
