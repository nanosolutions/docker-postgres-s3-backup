#!/bin/bash
set -e
fname="$PGDBNAME-$(date +%Y%m%d-%H%M%S).sql.gz"
pg_dump -Fc --clean --no-owner -h "$PGHOST" -U "$PGUSER" "$DBNAME" | gzip -c | cat > $fname
# create bucket
/usr/bin/s3cmd mb --host=${AWS_HOST} --host-bucket=  s3://${AWS_S3_BUCKET}
# upload
/usr/bin/s3cmd put --rr "$fname" --host=${AWS_HOST} --host-bucket=  s3://${AWS_S3_BUCKET}$fname
# clean up
rm -rf "$fname"
