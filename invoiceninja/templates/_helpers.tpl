{{/*
Return the proper image name
*/}}
{{- define "invoiceninja.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name
*/}}
{{- define "invoiceninja.nginx.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.http.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "invoiceninja.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.http.image .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "invoiceninja.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "invoiceninja.nginx.fullname" -}}
{{- printf "%s-%s" .Release.Name "nginx" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "invoiceninja.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{- default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the Invoice Ninja Secret Name
*/}}
{{- define "invoiceninja.secretName" -}}
{{- default (include "common.names.fullname" .) .Values.existingSecret }}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "invoiceninja.public.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence.public "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "invoiceninja.storage.storageClass" -}}
{{- include "common.storage.class" (dict "persistence" .Values.persistence.storage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Storage Name
*/}}
{{- define "invoiceninja.public.storageName" -}}
{{- printf "%s-%s" .Release.Name "public" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Storage Name
*/}}
{{- define "invoiceninja.storage.storageName" -}}
{{- printf "%s-%s" .Release.Name "storage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper app URL
*/}}
{{- define "invoiceninja.url" -}}
    {{- if .Values.appURL }}
        {{- printf "%s" .Values.appURL -}}
    {{- else if .Values.nginx.ingress.enabled }}
        {{- if .Values.nginx.ingress.tls }}
            {{- printf "https://%s" .Values.nginx.ingress.hostname -}}
        {{- else }}
            {{- printf "http://%s" .Values.nginx.ingress.hostname -}}
        {{- end }}
    {{- else if .Values.ingress.enabled }}
        {{- if .Values.ingress.tls }}
            {{- printf "https://%s" .Values.ingress.hostname -}}
        {{- else }}
            {{- printf "http://%s" .Values.ingress.hostname -}}
        {{- end }}
    {{- else }}
        {{- printf "http://%s" (include "common.names.fullname" .) -}}
    {{- end }}
{{- end -}}

{{/*
Return the MariaDB Hostname
*/}}
{{- define "invoiceninja.databaseHost" -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}

{{/*
Return the MariaDB Port
*/}}
{{- define "invoiceninja.databasePort" -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}

{{/*
Return the MariaDB Database Name
*/}}
{{- define "invoiceninja.databaseName" -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}

{{/*
Return the MariaDB User
*/}}
{{- define "invoiceninja.databaseUser" -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}

{{/*
Return the MariaDB Secret Name
*/}}
{{- define "invoiceninja.databaseSecretName" -}}
{{- if .Values.externalDatabase.existingSecret -}}
    {{- printf "%s" .Values.externalDatabase.existingSecret -}}
{{- end -}}
{{- end -}}

{{/*
Return the Redis Hostname
*/}}
{{- define "invoiceninja.redisHost" -}}
    {{- printf "%s" .Values.externalRedis.host -}}
{{- end -}}

{{/*
Return the Redis Port
*/}}
{{- define "invoiceninja.redisPort" -}}
    {{- printf "%d" (.Values.externalRedis.port | int ) -}}
{{- end -}}

{{/*
Return the Redis Database
*/}}
{{- define "invoiceninja.redisDatabase" -}}
    {{- printf "%s" .Values.externalRedis.databases.default -}}
{{- end -}}

{{/*
Return the Redis Database
*/}}
{{- define "invoiceninja.redisCacheDatabase" -}}
    {{- printf "%s" .Values.externalRedis.databases.cache -}}
{{- end -}}

{{/*
Return the Redis Secret Name
*/}}
{{- define "invoiceninja.redisSecretName" -}}
{{- if .Values.externalRedis.existingSecret -}}
    {{- printf "%s" .Values.externalRedis.existingSecret -}}
{{- else -}}
    {{- printf "%s" (include "invoiceninja.redis.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Broadcast Connection Name
*/}}
{{- define "invoiceninja.redisBroadcastConnection" -}}
{{- if (and .Values.externalRedis.host .Values.externalRedis.sentinel) }}
    {{- printf "sentinel-default" -}}
{{- else -}}
    {{- printf "default" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Cache Connection Name
*/}}
{{- define "invoiceninja.redisCacheConnection" -}}
{{- if or (and .Values.externalRedis.host .Values.externalRedis.sentinel) }}
    {{- printf "sentinel-cache" -}}
{{- else -}}
    {{- printf "cache" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Queue Connection Name
*/}}
{{- define "invoiceninja.redisQueueConnection" -}}
{{- if or (and .Values.externalRedis.host .Values.externalRedis.sentinel) }}
    {{- printf "sentinel-default" -}}
{{- else -}}
    {{- printf "default" -}}
{{- end -}}
{{- end -}}

{{/*
Return the Session Connection Name
*/}}
{{- define "invoiceninja.redisSessionConnection" -}}
{{- if or (and .Values.externalRedis.host .Values.externalRedis.sentinel) }}
    {{- printf "sentinel-default" -}}
{{- else -}}
    {{- printf "default" -}}
{{- end -}}
{{- end -}}

{{/*
Server block configmap name for nignx.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "invoiceninja.nginx.serverBlockName" -}}
{{- printf "%s-%s" .Release.Name "server-block" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of web service for inline web server.
*/}}
{{- define "invoiceninja.http.serviceName" -}}
{{- printf "%s-%s" .Release.Name "web" | trunc 63 | trimSuffix "-" -}}
{{- end -}}