{{- define "Tuckin.name" -}}{{ .Chart.Name }}{{- end }}
{{- define "Tuckin.labels" -}}
app.kubernetes.io/name: {{ include "Tuckin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
