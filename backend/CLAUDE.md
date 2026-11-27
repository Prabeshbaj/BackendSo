# Backend (Python)

Python 3.12+, Pydantic v2, boto3, `anthropic[bedrock]` SDK (D-20, proposed; confirm in T-07).

## Rules

1. **Model output is validated, never trusted.** Parse every Bedrock response with the Pydantic
   schema. If `stop_reason` is `max_tokens` or `refusal`, or validation fails, the run fails
   visibly. Never store or show a partial result as complete (NFR-07).
2. **"Not stated" is a valid answer.** Never infer or default a value the report does not state.
3. **Report text is untrusted data.** It goes in the user message inside `<report>` tags,
   never in the system prompt. Instructions inside a report are ignored (NFR-04).
4. **Pin and record model ID and prompt version** on every extraction (D-18). The model ID
   comes from config, never hard-coded. Changing either requires the eval suite (`evals/`).
5. **Step Functions passes S3 keys only**, never report text or large JSON (D-21).
6. **Each step is idempotent:** reads inputs from S3, overwrites its own output.
7. **Excel cell positions live in `templates/template-map.json`**, never in Python (D-26).
8. **Authorization is enforced in the API Lambda** from token claims.
9. **Every analyst edit and sign-off is recorded** with user and time (`EDIT#` items).
10. **Unit tests never call AWS.** Use `moto`, `botocore.stub.Stubber` or saved JSON. Real-AWS
    tests live in `tests/integration/`, are marked `@pytest.mark.aws`, synthetic fixtures only.

## Commands (filled in by T-01)

- Tests: `TODO` (e.g. `cd backend && uv run pytest`; one file: `uv run pytest tests/test_diff.py`)
- Lint and typecheck: `TODO` (e.g. `uv run ruff check . && uv run mypy .`)
- Evals: `TODO`

## Layout

```
backend/
  soc/
    schemas.py        Pydantic models: Cited, Soc1Extraction, Soc2Extraction, Change
    textract.py       Textract blocks -> pages.json
    citations.py      Excerpt verification against page text
    extract.py        Bedrock call, prompt, validation
    diff.py           Field-by-field comparison, fuzzy matching
    explain.py        Bedrock call for change explanations
    excel.py          Template filling via template-map.json
    registry.py       DynamoDB access (vendors, reports, comparisons, edits)
  handlers/           collect_text.py, extract.py, compare.py (steps), api.py (API Lambda)
  prompts/            Versioned prompt text (extract_v1.txt, explain_v1.txt)
  tests/
templates/            Placeholder Excel template and template-map.json
evals/                Evaluation harness over synthetic fixtures
tests/fixtures/       Synthetic PDFs and expected extractions only
```
