#!/usr/bin/env sh

UMASK=$(which umask)
UMASK_SET=${UMASK_SET:-022}

if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

DELUGED=$(which deluged)
DELUGED_LOGLEVEL=${DELUGED_LOGLEVEL:-info}
DELUGED_CONFIG=${DELUGED_CONFIG:-/config}
DELUGED_LOG=${DELUGED_LOG:-${DELUGED_CONFIG}/deluged.log}

if [[ ! -x $DELUGED ]]; then
  echo "deluged binary not found"
  exit 1
fi

echo $DELUGED -c ${DELUGED_CONFIG}/ -d --loglevel=${DELUGE_LOGLEVEL} -l ${DELUGED_LOG}
$DELUGED -c ${DELUGED_CONFIG}/ -d --loglevel=${DELUGE_LOGLEVEL} -l ${DELUGED_LOG}