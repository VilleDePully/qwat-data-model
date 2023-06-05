#!/usr/bin/env bash

# Exit on error
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/conduite.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/vanne_clapet.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/regulation_pression.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/station_pompage.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/station_traitement.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/reservoir.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/views_pully/captage.sql
