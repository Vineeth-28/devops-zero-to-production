# Template Functions & Objects

## Important Built-in Objects

| Object | Purpose |
|---|---|
| `.Values` | Values from `values.yaml` (or `-f`, `--set` overrides) |
| `.Release` | Info about the current release (name, namespace, revision) |
| `.Chart` | Info from `Chart.yaml` (name, version) |
| `.Capabilities` | Info about the Kubernetes cluster (API versions, etc.) |

Focus heavily on `.Values` and `.Release` — these are used constantly.

```
{{ .Values.replicaCount }}      → value from values.yaml
{{ .Values.image.repository }}  → nested value
{{ .Values.image.tag }}         → nested value
{{ .Release.Name }}             → e.g. "backend" (the release name)
{{ .Chart.Name }}               → e.g. "backend" (chart name from Chart.yaml)
```

## Control Structures

### `if`
```yaml
{{- if .Values.ingress.enabled }}
# ingress block only rendered if enabled
{{- end }}
```

### `range` (loops)
```yaml
env:
{{- range .Values.extraEnvVars }}
  - name: {{ .name }}
    value: {{ .value }}
{{- end }}
```

### `with` (scoping)
```yaml
{{- with .Values.resources }}
resources:
  limits:
    cpu: {{ .limits.cpu }}
{{- end }}
```

### `include`
Calls a named template (defined in `_helpers.tpl`) and inserts its output:
```yaml
labels:
  {{- include "backend.labels" . | nindent 4 }}
```

## Common Functions

| Function | Purpose | Example |
|---|---|---|
| `quote` | Wraps value in quotes | `{{ .Values.tag \| quote }}` → `"1.0.0"` |
| `default` | Fallback if value is empty | `{{ .Values.tag \| default "latest" }}` |
| `required` | Fails render if value missing | `{{ required "image.tag is required" .Values.image.tag }}` |
| `toYaml` | Converts a map/list to YAML | `{{ toYaml .Values.resources }}` |
| `nindent` | Indents + adds newline (used with toYaml/include) | `{{ toYaml .Values.resources \| nindent 4 }}` |

## Note

Helm's templating language has dozens of functions (Sprig library). **Do not try to memorize all of them.** Know `.Values`, `.Release`, `.Chart`, `if`/`range`/`with`/`include`, and `default`/`required`/`quote`/`toYaml`/`nindent` — that covers the vast majority of real-world charts and interview questions.
