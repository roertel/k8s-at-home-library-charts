{{/*
This template serves as a blueprint for all HTTPRoute objects that are created
within the common library.
*/}}
{{- define "common.classes.httproute" -}}
  {{- $fullName := include "common.names.fullname" . -}}
  {{- $httprouteName := $fullName -}}
  {{- $values := .Values.httproute -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.httproute -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $httprouteName = printf "%v-%v" $httprouteName $values.nameOverride -}}
  {{- end -}}

  {{- $primaryService := get .Values.service (include "common.service.primary" .) -}}
  {{- $defaultServiceName := $fullName -}}
  {{- if and (hasKey $primaryService "nameOverride") $primaryService.nameOverride -}}
    {{- $defaultServiceName = printf "%v-%v" $defaultServiceName $primaryService.nameOverride -}}
  {{- end -}}
  {{- $defaultServicePort := get (get $primaryService.ports (include "common.classes.service.ports.primary" (dict "values" $primaryService))) "port" -}}
  {{- $isStable := include "common.capabilities.httproute.isStable" . }}
---
apiVersion: {{ include "common.capabilities.httproute.apiVersion" . }}
kind: HTTPRoute
metadata:
  name: {{ $httprouteName }}
  {{- with (merge ($values.labels | default dict) (include "common.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "common.annotations" $ | fromYaml)) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if and $isStable $values.httprouteClassName }}
  httprouteClassName: {{ $values.httprouteClassName }}
  {{- end }}
  {{- if $values.hostnames }}
  hostnames:
  {{- range $values.hostnames }}
  - {{ tpl . $ | quote }}
  {{- end }}
  {{- end }}
  {{- if $values.parentRefs }}
  parentRefs:
  {{- range $values.parentRefs }}
  - name: {{ .name }}
    {{- if .group }}
    group: {{ .group }}
    {{- end }}
    {{- if .kind }}
    kind: {{ .kind }}
    {{- end }}
    {{- if .namespace }}
    namespace: {{ .namespace }}
    {{- end }}
  {{- end }}
  {{- end }}
  {{- if $values.rules }}
  rules:
  {{- range $values.rules }}
  {{- if .backendRefs }}
  - backendRefs:
    {{- range .backendRefs }}
    {{- $name := $defaultServiceName -}}
    {{- $port := $defaultServicePort -}}
    {{- if .name -}}
      {{- $name = default $name .name -}}
    {{- end }}
    {{- if .port -}}
      {{- $port = default $port .port -}}
    {{- end }}
    - name: {{ $name }}
      port: {{ $port }}
      {{- if .group }}
      group: {{ .group }}
      {{- end }}
      {{- if .kind }}
      kind: {{ .kind }}
      {{- end }}
      {{- if .weight }}
      namespace: {{ .weight }}
      {{- end }}
    {{- end }}
    {{- end }}
    {{- if .matches }}
    {{- if not .backendRefs }}
  - matches:
    {{- else }}
    matches:
    {{- end }}
    {{- tpl (.matches | toYaml | nindent 4) $ }}
    {{- end }}

    {{- end }}
  {{- end }}
{{- end }}
