#!/bin/bash
set -Eeuo pipefail

# Start RethinkDB in the background
# We use "$@" to allow passing arguments from CMD
echo "Starting RethinkDB..."
rethinkdb "$@" &
PID=$!

# Function to handle termination
_term() {
  echo "Caught SIGTERM signal! Stopping RethinkDB (PID $PID)..."
  kill -TERM "$PID" 2>/dev/null
  wait "$PID"
}

trap _term SIGTERM

# Wait for RethinkDB to start and be ready for connections
echo "Waiting for RethinkDB to be ready..."
MAX_RETRIES=30
COUNT=0
# Check if port 28015 is open
until (echo > /dev/tcp/localhost/28015) >/dev/null 2>&1 || [ $COUNT -eq $MAX_RETRIES ]; do
  sleep 2
  COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
  echo "Timed out waiting for RethinkDB to start."
  exit 1
fi

# Create the 'dog' database if it doesn't exist
# We use a python one-liner to check and create the database
python3 -c "
import rethinkdb as r
import sys

try:
    conn = r.r.connect('localhost', 28015)
    dbs = r.r.db_list().run(conn)
    if 'dog' not in dbs:
        print('Creating database \'dog\'...')
        r.r.db_create('dog').run(conn)
    else:
        print('Database \'dog\' already exists.')
    conn.close()
except Exception as e:
    print(f'Error connecting to RethinkDB: {e}')
    sys.exit(1)
"

# Wait for the RethinkDB process to exit
wait "$PID"
