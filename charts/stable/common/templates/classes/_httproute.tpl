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
  {{- $defaultServicePort := get $primaryService.ports (include "common.classes.service.ports.primary" (dict "values" $primaryService)) -}}
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
  hostnames:
  {{- range $values.hostnames }}
  - {{ . }}
  {{- end }}
  parentRefs:
  {{- range $values.parentRefs }}
  - {{ . }}
  {{- end }}
  rules:
  {{- range $values.rules }}
  - {{ . }}
  {{- end }}
{{- end }}
