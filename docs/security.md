# Security notes

Working notes for v1, not a formal threat model. Items marked **[unverified]** need checking
against current AWS documentation or InfoSec.

## Data

- Real SOC reports are not used anywhere until InfoSec and Legal approve (O-4). Until then:
  synthetic fixtures only, in every account and every repo.
- Report content stays in the firm's AWS accounts; Claude is called only through Bedrock
  (D-02, NFR-01). Account, region and cross-region routing are open (O-2).
- S3 and DynamoDB are encrypted with a customer-managed KMS key; buckets block public access
  and are versioned (NFR-02). Retention is open (O-9).
- Logs never contain report text or excerpts. Log IDs, S3 keys, counts and errors.

## Prompt injection

- Report text is untrusted (NFR-04): user message only, inside `<report>` tags, never in the
  system prompt.
- Model output is parsed with Pydantic and cited excerpts are verified in code (D-10), so an
  injected instruction cannot add an unverified finding silently.
- The model has no tools and no write access; it returns JSON only.

## Identity and access

- Okta OIDC with PKCE (D-05a). The API validates the access token; authorizer type depends on
  O-3 and O-12 (D-15 proposed).
- Roles (analyst, manager, auditor, admin) come from an Okta group claim (claim name O-12).
  Authorization is checked in the API Lambda, not the UI.
- One IAM role per Lambda, least privilege. Only `extract` and `compare` can call Bedrock.

## Audit

- Every upload, extraction, edit and sign-off is recorded with user and time (NFR-05):
  DynamoDB `EDIT#` items plus CloudTrail. Tamper-proof storage (S3 Object Lock) is deferred
  (T-35).
- Each extraction records model ID and prompt version (D-18).

## Open before production

O-2, O-3, O-4, O-5, O-9, O-12, O-13, and T-34 (pre-real-data checklist).
