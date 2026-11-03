{{- define "mealtrail.name" -}}{{ .Chart.Name }}{{- end }}
{{- define "mealtrail.labels" -}}
app.kubernetes.io/name: {{ include "mealtrail.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
