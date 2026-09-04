# Troubleshooting: Helm Template Errors

## Scenario: Invalid Template Syntax

```
helm template
    ↓
Template error
```

**Problem:** Chart fails to render — no manifests are ever produced.

**Symptoms:**
```
Error: parse error at (backend/templates/deployment.yaml:8):
unexpected "}" in operand
```

**Commands:**
```bash
helm lint ./charts/backend
helm template backend ./charts/backend --debug
```

**Investigation:** `--debug` shows the exact rendering step and often the partially-rendered YAML up to the failure point — check for mismatched `{{`/`}}`, missing `end` for an `if`/`range`, or bad indentation from `nindent`.

**Root Cause:** Usually one of:
- Unclosed `{{- if }}` (missing `{{- end }}`)
- Wrong `nindent` value causing invalid YAML indentation
- Referencing `.Values.x.y` where `x` doesn't exist (nil pointer)

**Fix:** Locate the exact file/line from the error, fix the template syntax.

**Verification:** `helm lint` passes with no errors; `helm template` outputs valid YAML.

---

## Scenario: Wrong Values Produce Unexpected Output

```
values-production.yaml
    ↓
Unexpected production configuration
```

**Problem:** Chart renders successfully, but the rendered YAML doesn't match what was intended (e.g. wrong replica count, missing ingress).

**Commands:**
```bash
helm template backend ./charts/backend -f values-production.yaml > rendered.yaml
```

**Investigation:** Read `rendered.yaml` directly — compare against what's expected. Common cause: forgot that a values file only **overrides** `values.yaml`, so a key not present in `values-production.yaml` silently falls back to the default.

**Root Cause:** Missing override in the environment-specific values file, or a typo'd key that Helm silently ignores (unknown keys don't error unless referenced with `required`).

**Fix:** Add the missing key to the correct values file; consider using `required` in the template for critical values to catch this earlier.

**Verification:** `helm template` output matches expectations exactly.
