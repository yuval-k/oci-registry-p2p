{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "oci-registry-p2p.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oci-registry-p2p.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oci-registry-p2p.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "oci-registry-p2p.labels" -}}
helm.sh/chart: {{ include "oci-registry-p2p.chart" . }}
{{ include "oci-registry-p2p.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "oci-registry-p2p.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oci-registry-p2p.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "oci-registry-p2p.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "oci-registry-p2p.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Generate certificates.
see:  https://medium.com/nuvo-group-tech/move-your-certs-to-helm-4f5f61338aca
*/}}
{{- define "oci-registry-p2p.gen-certs" -}}
{{- $altNames := list ( printf "%s.%s" (include "oci-registry-p2p.name" .) .Release.Namespace ) ( printf "%s.%s.svc" (include "oci-registry-p2p.name" .) .Release.Namespace ) -}}
{{- $ca := genCA "oci-registry-p2p-ca" 365 -}}
{{- $cert := genSignedCert ( include "oci-registry-p2p.name" . ) nil $altNames 365 $ca -}}
tls.crt: {{ $cert.Cert | b64enc }}
tls.key: {{ $cert.Key | b64enc }}
{{- end -}}