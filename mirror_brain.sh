#!/bin/bash

HOST=mirror@pontifex2-opensuse

# MB_HOST=149.44.161.13
MB_HOST=mirrordb-opensuse.suse.de
MB_PASSWD=`cat mbpasswd`
MB_SQL="SELECT hash.size, to_timestamp(hash.mtime)::date, filearr.path
        FROM hash, filearr
        WHERE filearr.id=hash.file_id
           AND (filearr.path LIKE '%rpm' OR filearr.path LIKE '%.iso' or filearr.path LIKE '%.xml%')
           AND filearr.path NOT LIKE 'ensuse/%';"

### AND filearr.path NOT LIKE 'repositories/home:%';\""

echo 'Getting the package list ...'
PGPASSWORD=$MB_PASSWD psql -U rsyncsize -h $MB_HOST -t -A -F ' ' mb_opensuse -c "$MB_SQL" > mirror_brain.txt

date +%Y-%m-%d > last_time_mb

# Wake up the rest of the process
:> lock-dir/kp.lock
