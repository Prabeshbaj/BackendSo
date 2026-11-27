---
name: spec-task
description: Write the spec for one implementation-plan task (T-xx) before any code is written. Use at the start of every task.
disable-model-invocation: true
---
Write the spec for task $ARGUMENTS. Do not edit code.

1. Find the task row in `docs/implementation-plan.md`. Note its "Done when", "Test" and Refs.
2. Read the FR-xx / NFR-xx it covers in `docs/requirements.md`, the D-xx and O-xx it touches
   in `docs/decisions.md`, and the relevant section of `docs/architecture.md`.
3. Read the existing code the task touches. Reuse what is there.
4. List every Open (O-xx) item the task depends on. If one blocks the task (the plan marks it
   **Blocked**), stop and say so.
5. If the task uses a model ID, AWS limit, quota or price, look up current documentation and
   cite it in the spec. Mark anything you could not verify.
6. Ask the human about the hard parts: edge cases, failure modes, IAM, idempotency, anything
   the docs leave open. Do not guess.
7. Copy `docs/specs/_template.md` to `docs/specs/$ARGUMENTS-<short-name>.md` and fill it in.
   Replace "UI states" with "Failure modes". Every FR gets at least one test row. End with
   the verification commands (and the change set to show, for template tasks).
8. If the task changes an API route, list the `docs/api-contract.md` change; FrontendSO
   needs the same change.
9. Stop and ask the human to review the spec.
