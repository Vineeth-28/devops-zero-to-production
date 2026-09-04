{{/*
Common name for resources, based on release name.
*/}}
{{- define "backend.fullname" -}}
{{ .Release.Name }}
{{- end -}}

{{/*
Common labels applied to every resource in this chart.
*/}}
{{- define "backend.labels" -}}
app: backend
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/*
Selector labels — must stay stable across upgrades (used by
Deployment/Service to match pods). Do not add version info here.
*/}}
{{- define "backend.selectorLabels" -}}
app: backend
release: {{ .Release.Name }}
{{- end -}}
