#!/usr/bin/env bash

#Exit on error
set -e

DIR=$(git rev-parse --show-toplevel)

if [[ $QWAT_SIGIP =~ ON ]]; then
  psql -v ON_ERROR_STOP=1 -f ${DIR}/extensions/sigip/drop_views.sql
fi
psql -v ON_ERROR_STOP=1 -f ${DIR}/ordinary_data/views/drop_views.sql


${DIR}/ordinary_data/views/insert_views.sh
if [[ $QWAT_CH_VD_SIRE =~ ON ]]; then
  ${DIR}/extensions/sigip/insert_views.sh
fi
