#!/bin/bash
set -e

COMMANDS="adduser debug fg foreground help kill logreopen logtail reopen_transcript run show status stop wait"
START="console start restart"
# if [[ -z "$ZEO_ADDRESS" ]]; then
# 	INSTANCE="bin/client1"
# else
# 	INSTANCE="bin/instance"
# fi

su-exec plone python /docker-initialize.py

if [ -e "custom.cfg" ]; then
  if [ ! -e "bin/develop" ]; then
    buildout -c custom.cfg
    chown -R plone:plone /plone
    su-exec plone python /docker-initialize.py
  fi
fi

DATAFS=/data/filestorage/Data.fs
# ZEO Server
if [[ "$1" == "zeo"* ]]; then
  if [[ ! -e "$DATAFS" ]]; then
    echo "No Plone site, create one with plonesite buildout parts"
    su-exec plone buildout -c buildout-restapi.cfg install plonesite
  fi
  exec su-exec plone bin/$1 fg
fi

# Plone instance start
if [[ $START == *"$1"* ]]; then
  if [[ ! -e "$DATAFS" ]] && [[ -z "$ZEO_ADDRESS" ]]; then
    echo "No Plone site, create one with plonesite buildout parts"
	ls -lah /data
	ls -lah /data/filestorage
    su-exec plone buildout -c buildout-restapi.cfg install plonesite
	ls -lah /data/filestorage
  fi
  exec su-exec plone bin/instance console
fi

# Plone instance helpers
if [[ $COMMANDS == *"$1"* ]]; then
  exec su-exec plone bin/instance "$@"
fi

# Custom
exec "$@"
