# Infrastructure (CloudFormation)

Plain CloudFormation YAML, deployed from the local AWS CLI (D-16). No CDK, SAM or Terraform.
CI/CD is deferred.

## Rules

1. **Every AWS resource is created by a template in `infra/templates/`**, one stack per area.
   No console clicks, no ad-hoc `aws ... create-*` / `put-*` calls. Missing resource: add it
   to a template.
2. **Lint every template with `cfn-lint`** before deploying.
3. **Show the change set (`--no-execute-changeset`) and get the human's go-ahead** before
   executing it. Never execute a change set the human has not seen.
4. **Least privilege per role.** Only `extract` and `compare` roles get `bedrock:InvokeModel`;
   only the state machine role gets Textract. pytest asserts this.
5. **Encryption and access:** KMS on buckets and table, block public access, versioning,
   PITR on DynamoDB. Retention is open (O-9): no lifecycle expiry until it is answered.
6. **API Gateway type and authorizer depend on O-3 and O-12** (D-15 proposed). Do not pick one.

## Commands (filled in by T-01)

```
cfn-lint infra/templates/*.yaml
./infra/deploy.sh <stack> <env>     # package + deploy --no-execute-changeset
```

`deploy.sh` wraps:

```
aws cloudformation package --template-file infra/templates/<stack>.yaml \
  --s3-bucket <artifacts-bucket> --output-template-file infra/build/<stack>.packaged.yaml
aws cloudformation deploy --template-file infra/build/<stack>.packaged.yaml \
  --stack-name soc-<env>-<stack> --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides Env=<env> --no-execute-changeset
```

## Layout

```
infra/
  templates/
    bootstrap.yaml    Artifacts bucket for packaged Lambda code
    storage.yaml      KMS key, reports bucket, DynamoDB table
    pipeline.yaml     Step Lambdas, state machine, EventBridge rule, IAM roles
    api.yaml          API Lambda, API Gateway, authorizer
    frontend.yaml     SPA bucket, CloudFront (SPA built in FrontendSO, D-27)
  state_machine.asl.json
  params/dev.json
  deploy.sh
  build/              Packaged templates (git-ignored)
```
