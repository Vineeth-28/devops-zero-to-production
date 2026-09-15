# Ansible in CI/CD

**Mental model:**
```
Developer
    ↓
GitHub
    ↓
Jenkins / GitHub Actions
    ↓
Validation
    ↓
Build
    ↓
Ansible
    ↓
Target Servers
    ↓
Application Deployment
```

## CI/CD Integration Pieces

**Validation stage:** `ansible-playbook site.yml --syntax-check`, `ansible-lint`, and `ansible-playbook site.yml --check --diff` against a throwaway/staging target before touching prod.

**Inventory/environment selection:** Pass the environment explicitly, never rely on a default — `ansible-playbook site.yml -i inventory/staging` vs `-i inventory/prod`, ideally chosen by the pipeline stage/branch, not a manual flag someone can forget.

**Secure authentication:**
- SSH private key injected via the CI platform's secret store (e.g., GitHub Actions `secrets.SSH_PRIVATE_KEY`), written to a temp file at runtime, never committed.
- Vault password similarly injected as a CI secret and passed with `--vault-password-file <(echo "$VAULT_PASSWORD")` or a mounted secret file — never hardcoded in the pipeline YAML.

Example (illustrative, placeholders only):
```yaml
# .github/workflows/deploy.yml (excerpt)
- name: Run Ansible deploy
  env:
    ANSIBLE_VAULT_PASSWORD: ${{ secrets.ANSIBLE_VAULT_PASSWORD }}
  run: |
    echo "$ANSIBLE_VAULT_PASSWORD" > /tmp/vault_pass
    ansible-playbook deploy.yml \
      -i inventory/prod \
      --vault-password-file /tmp/vault_pass \
      --limit webservers \
      --tags deploy
    rm -f /tmp/vault_pass
```

**Idempotent deployment:** Because tasks are idempotent, re-running the same pipeline job (e.g., after a transient network blip) converges to the same state instead of duplicating work — this is what makes CI/CD retries safe.

**Approvals:** Gate the prod stage behind a manual approval step (GitHub Environments protection rules, Jenkins input step) even though staging can run fully automated.

**Rollback considerations:** Keep the previous release artifact/version tag available (see `playbooks/deploy.yml`'s `RELEASE` marker pattern) so a rollback is just re-running the deploy playbook with the prior `release_version`, not a manual fix.

**Production use:** Staging deploys run on every merge to main automatically; prod deploys run the same playbook, same tags, with only the inventory/approval gate differing — never a divergent "prod-only" playbook.

**Common mistakes:** Different playbooks (or worse, manually-run commands) for staging vs prod, so prod behavior is untested by the time it matters; storing the vault password as a plain pipeline variable instead of a proper CI secret; no approval gate before prod, turning every merge into an uncontrolled prod deploy.

**Troubleshooting:** See "CI/CD Execution Failures" in `troubleshooting/ansible-troubleshooting.md` — most pipeline-only failures are missing secrets or wrong inventory selection, not playbook logic.

**Interview-ready answer:** "The pipeline runs the exact same playbook against staging automatically and against prod behind a manual approval gate, with SSH keys and the vault password injected from the CI secret store at runtime — never committed. Idempotency is what makes retries safe, and rollbacks are just re-running deploy with the previous release version rather than a separate process."
