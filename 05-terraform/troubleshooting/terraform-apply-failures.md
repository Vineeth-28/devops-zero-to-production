# Troubleshooting — terraform apply Failures

## Scenario 4: `terraform apply` fails

**Problem:** `plan` looked fine, but `apply` errors out partway through.

**Symptoms:**
```
Error: creating EC2 Instance: InvalidParameterValue: ...
Error: error creating S3 Bucket: BucketAlreadyExists
Apply partially completed — some resources created, others not
```

**Commands:**
```bash
terraform apply
terraform state list
TF_LOG=DEBUG terraform apply
```

**Investigation:**
- Read the exact API error returned by the provider — it usually names
  the actual AWS-side rejection reason (invalid parameter, quota
  exceeded, name collision, permission denied).
- Run `terraform state list` to see exactly which resources succeeded
  before the failure — Terraform records each resource as it's created,
  so a partial apply is not "all or nothing."
- For a global-namespace resource (like an S3 bucket name), check
  whether the name is already taken by *anyone*, not just your account.

**Root Cause (typical):** a naming collision, an account service quota,
a missing IAM permission, or an invalid value only the API itself
rejects (not caught by `validate`).

**Fix:**
- Correct the offending value (rename the bucket, request a quota
  increase, fix the IAM policy).
- Re-run `terraform apply` — Terraform will skip the resources already
  created successfully and retry only what's left, because state
  already reflects the partial success.

**Verification:** `terraform apply` completes fully; `terraform plan`
afterward shows "No changes."

---

## Scenario 5: Provider authentication fails

**Symptoms:**
```
Error: error configuring Terraform AWS Provider: no valid credential sources found
Error: UnauthorizedOperation
Error: AccessDenied
```

**Commands:**
```bash
aws sts get-caller-identity   # confirm which identity Terraform will use
echo $AWS_PROFILE
echo $AWS_ACCESS_KEY_ID       # just to confirm it's SET, never print the secret
```

**Investigation:**
- Confirm which credential source is actually active — environment
  variables, a named profile, or an assumed role — and that it matches
  what you intended.
- Check the IAM policy attached to that identity actually allows the
  specific actions Terraform is trying to perform (e.g. `ec2:RunInstances`,
  `s3:CreateBucket`).
- Check for an expired session token if using temporary/assumed-role
  credentials.

**Root Cause (typical):** wrong/expired credentials active, or
insufficient IAM permissions for the specific action.

**Fix:** Re-authenticate (refresh SSO session, re-assume the role,
correct the profile), or update the IAM policy to grant the missing
permission — following least privilege, not blanket admin access.

**Verification:** `aws sts get-caller-identity` returns the expected
identity; `terraform plan` runs without authentication errors.
