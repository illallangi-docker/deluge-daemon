#!/usr/bin/env sh

UMASK=$(which umask)
UMASK_SET=${UMASK_SET:-022}

if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

CONFD=$(which confd)

if [[ ! -x $CONFD ]]; then
  echo "confd binary not found"
  exit 1
fi

echo $CONFD -onetime -backend env -log-level debug
$CONFD -onetime -backend env -log-level debug || exit 1

DELUGED=$(which deluged)
DELUGE_DAEMON_LOGLEVEL=${DELUGE_DAEMON_LOGLEVEL:-info}
DELUGE_DAEMON_CONFIG=${DELUGE_DAEMON_CONFIG:-/config}

if [[ ! -x $DELUGED ]]; then
  echo "deluged binary not found"
  exit 1
fi

echo ${*:-${DELUGED} --config ${DELUGE_DAEMON_CONFIG}/ --loglevel ${DELUGE_DAEMON_LOGLEVEL} --do-not-daemonize}
exec ${*:-${DELUGED} --config ${DELUGE_DAEMON_CONFIG}/ --loglevel ${DELUGE_DAEMON_LOGLEVEL} --do-not-daemonize}