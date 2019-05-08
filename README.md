# Postgres to S3 backup tools

CronJob image tamplate to user with CronJOb

#### Build

```
TAG=0.0.2
docker build -t stirlinglabs/s3pgbackup:$TAG .
docker tag stirlinglabs/s3pgbackup:$TAG registry.freo.cloud/stirlinglabs/s3pgbackup:$TAG
docker push registry.freo.cloud/stirlinglabs/s3pgbackup:$TAG
curl https://registry.freo.cloud/v2/stirlinglabs/s3pgbackup/tags/list
```

#### Environment variables

`PGHOST` - databse host 
`PGDATABASE` 
`PGUSER`
`PGPASSWORD`
`AWS_HOST`
`AWS_ENDPOINT`
`AWS_S3_BUCKET` - provided form Secet
`AWS_SECRET_ACCESS_KEY` - provided form Secet


#### Example CronJob Helm Chart

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: {{ include "space.fullname" . }}-cronjob
  labels:
    app.kubernetes.io/name: {{ include "space.name" . }}
    helm.sh/chart: {{ include "space.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
spec:
  schedule: "0 */12 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          imagePullSecrets:
          - name: {{ .Values.imagePullSecret }}
          restartPolicy: OnFailure
          containers:
          - name: s3pgbackup
            image: registry.freo.cloud/stirlinglabs/s3pgbackup:0.0.2
            env:
            - name: PGHOST
              value: "{{ .Release.Name }}-postgresql.{{ .Release.Namespace }}.svc.cluster.local"
            - name: PGDATABASE
              value: "{{ .Values.postgresql.postgresqlDatabase }}"
            - name: PGUSER
              value: "{{ .Values.postgresql.postgresqlUsername }}"
            - name: PGPASSWORD
              value: "{{ .Values.postgresql.postgresqlPassword }}"
            - name: PGDBNAME
              value: "{{ .Values.postgresql.postgresqlDatabase }}"
            - name: AWS_HOST
              value: "{{ .Values.postgresql.s3backup }}"
            - name: AWS_ENDPOINT
              value: "{{ .Values.postgresql.s3backup }}"
            - name: AWS_S3_BUCKET
              value: "{{ include "space.fullname" . }}"
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: rook-ceph-object-user-my-store-my-user
                  key: AccessKey
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: rook-ceph-object-user-my-store-my-user
                  key: SecretKey

```