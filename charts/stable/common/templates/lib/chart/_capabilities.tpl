{{/* Allow KubeVersion to be overridden. */}}
{{- define "common.capabilities.ingress.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Return the appropriate apiVersion for Ingress objects */}}
{{- define "common.capabilities.ingress.apiVersion" -}}
  {{- print "networking.k8s.io/v1" -}}
  {{- if semverCompare "<1.19" (include "common.capabilities.ingress.kubeVersion" .) -}}
    {{- print "beta1" -}}
  {{- end -}}
{{- end -}}

{{/* Check Ingress stability */}}
{{- define "common.capabilities.ingress.isStable" -}}
  {{- if eq (include "common.capabilities.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
    {{- true -}}
  {{- end -}}
{{- end -}}

{{/* HTTPRoute */}}
{{- define "common.capabilities.httproute.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Return the appropriate apiVersion for HTTPRoute objects */}}
{{- define "common.capabilities.httproute.apiVersion" -}}
  {{- print "gateway.networking.k8s.io/v1" -}}
  {{- if semverCompare "<1.19" (include "common.capabilities.httproute.kubeVersion" .) -}}
    {{- print "beta1" -}}
  {{- end -}}
{{- end -}}

{{/* Check HTTPRoute stability */}}
{{- define "common.capabilities.httproute.isStable" -}}
  {{- if eq (include "common.capabilities.httproute.apiVersion" .) "gateway.networking.k8s.io/v1" -}}
    {{- true -}}
  {{- end -}}
{{- end -}}
