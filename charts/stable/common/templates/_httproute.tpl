{{/* Renders the HTTPRoute objects required by the chart */}}
{{- define "common.httproute" -}}
  {{- /* Generate named HTTP route as required */ -}}
  {{- range $name, $httproute := .Values.httproute }}
    {{- if $httproute.enabled -}}
      {{- $httprouteValues := $httproute -}}

      {{/* set defaults */}}
      {{- if and (not $httprouteValues.nameOverride) (ne $name (include "common.httproute.primary" $)) -}}
        {{- $_ := set $httprouteValues "nameOverride" $name -}}
      {{- end -}}

      {{- $_ := set $ "ObjectValues" (dict "httproute" $httprouteValues) -}}
      {{- include "common.classes.httproute" $ }}
    {{- end }}
  {{- end }}
{{- end }}

{{/* Return the name of the primary httproute object */}}
{{- define "common.httproute.primary" -}}
  {{- $enabledHTTPRoutes := dict -}}
  {{- range $name, $httproute := .Values.httproute -}}
    {{- if $httproute.enabled -}}
      {{- $_ := set $enabledHTTPRoutes $name . -}}
    {{- end -}}
  {{- end -}}

  {{- $result := "" -}}
  {{- range $name, $httproute := $enabledHTTPRoutes -}}
    {{- if and (hasKey $httproute "primary") $httproute.primary -}}
      {{- $result = $name -}}
    {{- end -}}
  {{- end -}}

  {{- if not $result -}}
    {{- $result = keys $enabledHTTPRoutes | first -}}
  {{- end -}}
  {{- $result -}}
{{- end -}}
