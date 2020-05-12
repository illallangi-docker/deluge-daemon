#!/usr/bin/env sh

UMASK_SET=${UMASK_SET:-022}

CONFD=$(which confd)
GOSU=$(which gosu)
DELUGED=$(which deluged)

if [[ ! -x ${CONFD} ]]; then
  echo "confd binary not found"
  exit 1
fi

if [[ ! -x ${GOSU} ]]; then
  echo "gosu binary not found"
  exit 1
fi

if [[ ! -x $DELUGED ]]; then
  echo "deluged binary not found"
  exit 1
fi

echo umask "$UMASK_SET"
umask "$UMASK_SET" || exit 1

if [[ ${UID} -eq 0 ]]; then

  echo ${CONFD} -onetime -backend env -log-level debug
  ${CONFD} -onetime -backend env -log-level debug || exit 1

  echo usermod -u ${PUID} abc
  usermod -u ${PUID} abc || exit 1
  echo groupmod -g ${PGID} abc
  groupmod -g ${PGID} abc || exit 1
  echo usermod -g ${PUID} abc
  usermod -g ${PUID} abc || exit 1

  echo mkdir -p  /config /data/complete /data/disk /data/downloading /data/watch
  mkdir -p /config /data/complete /data/disk /data/downloading /data/watch || exit 1
  echo chown -R -v ${PUID}:${PGID} /config /data/complete /data/disk /data/downloading /data/watch
  chown -R -v ${PUID}:${PGID} /config /data/complete /data/disk /data/downloading /data/watch || exit 1

  echo ${GOSU} abc $0 $*
  ${GOSU} abc $0 $* || exit 1

else

  DELUGE_DAEMON_LOGLEVEL=${DELUGE_DAEMON_LOGLEVEL:-info}
  DELUGE_DAEMON_CONFIG=${DELUGE_DAEMON_CONFIG:-/config}

  echo ${*:-${DELUGED} --config ${DELUGE_DAEMON_CONFIG}/ --loglevel ${DELUGE_DAEMON_LOGLEVEL} --do-not-daemonize}
  exec ${*:-${DELUGED} --config ${DELUGE_DAEMON_CONFIG}/ --loglevel ${DELUGE_DAEMON_LOGLEVEL} --do-not-daemonize}

fi
