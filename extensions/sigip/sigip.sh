#!/usr/bin/env bash

# Exit on error
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

psql -c "CREATE SCHEMA IF NOT EXISTS qwat_sigip;"
psql -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/damage/damage.sql

${DIR}/insert_views.sh