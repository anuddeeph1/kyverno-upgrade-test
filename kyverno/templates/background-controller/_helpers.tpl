{{/* vim: set filetype=mustache: */}}

{{- define "kyverno.background-controller.name" -}}
{{ template "kyverno.name" . }}-background-controller
{{- end -}}

{{- define "kyverno.background-controller.labels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.labels.common" .)
  (include "kyverno.background-controller.matchLabels" .)
) -}}
{{- end -}}

{{- define "kyverno.background-controller.matchLabels" -}}
{{- template "kyverno.labels.merge" (list
  (include "kyverno.matchLabels.common" .)
  (include "kyverno.labels.component" "background-controller")
) -}}
{{- end -}}

{{- define "kyverno.background-controller.image" -}}
{{- $tag := default .defaultTag .image.tag -}}
{{- $imageRegistry := default (default .image.defaultRegistry .globalRegistry) .image.registry -}}
{{- $fipsEnabled := .fipsEnabled -}}
{{- if $imageRegistry -}}
    {{- if $fipsEnabled -}}
      {{ $imageRegistry }}/{{ required "An image repository is required" .image.repository }}-fips:{{ $tag }}
    {{- else -}}
      {{ $imageRegistry }}/{{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
    {{- end -}}
{{- else -}}
  {{ required "An image repository is required" .image.repository }}:{{ default .defaultTag .image.tag }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.roleName" -}}
{{ include "kyverno.fullname" . }}:background-controller
{{- end -}}

{{- define "kyverno.background-controller.serviceAccountName" -}}
{{- if .Values.backgroundController.rbac.create -}}
    {{ default (include "kyverno.background-controller.name" .) .Values.backgroundController.rbac.serviceAccount.name }}
{{- else -}}
    {{ required "A service account name is required when `rbac.create` is set to `false`" .Values.backgroundController.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kyverno.background-controller.caCertificatesConfigMapName" -}}
{{ printf "%s-ca-certificates" (include "kyverno.background-controller.name" .) }}
{{- end -}}
