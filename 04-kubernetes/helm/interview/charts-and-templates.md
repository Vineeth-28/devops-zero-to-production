# Interview: Charts & Templates

### What does `.Values` mean?
**Expected answer:** Refers to the merged configuration values available to templates — from `values.yaml`, plus any `-f` files or `--set` overrides applied at install/upgrade time.
**Key points:** Later sources override earlier ones (values.yaml → -f file → --set, in increasing priority).
**Common mistake:** Forgetting `--set` overrides values files, not the other way around.

### What is `.Release.Name`?
**Expected answer:** The name given to the release at install time (e.g. `backend` in `helm install backend ./chart`).
**Key points:** Commonly used to name resources uniquely per release, e.g. `{{ .Release.Name }}-config`.
**Common mistake:** Confusing `.Release.Name` with `.Chart.Name` (chart name is static, defined in Chart.yaml; release name is chosen at install time).

### What does `helm template` do?
**Expected answer:** Renders the chart to plain Kubernetes YAML locally, without contacting the cluster or creating a release.
**Key points:** Safe, side-effect-free way to preview exactly what would be applied.
**Common mistake:** Confusing it with `helm install --dry-run` (similar purpose, but `--dry-run` does contact the cluster to validate against the API server, `helm template` does not by default).

### What does `helm lint` do?
**Expected answer:** Validates a chart's structure and templates for common issues (missing required fields, bad YAML) without rendering full output.
**Key points:** Fast to run, good first CI step.
**Common mistake:** Assuming `helm lint` catches every possible error — it doesn't guarantee the rendered YAML is valid against the live cluster's API version.

### Explain `if`, `range`, `with`, `include` in one sentence each.
**Expected answer:**
- `if` — conditionally render a block
- `range` — loop over a list/map
- `with` — change the scope (`.`) for a block
- `include` — call a named template (defined in `_helpers.tpl`) and insert its output

**Common mistake:** Using `with` and then being confused that `.Values` inside the block now means something different — `with` changes what `.` refers to.

### What's the purpose of `_helpers.tpl`?
**Expected answer:** Defines reusable named templates (like functions) — most commonly shared labels/selectors — to avoid repeating the same block in every manifest file.
**Key points:** Called via `{{ include "name" . }}`.
**Common mistake:** Forgetting to pass `.` as the context when calling `include` — without it, the named template can't see `.Values`/`.Release`.
