#!/bin/bash

COMMAND="${1:-}"

if [ "${COMMAND}" == "hiveserver" ]; then

    echo "Starting JDBC Server ..."

    ${HIVE_HOME}/bin/hive --service schematool -initSchema -dbType postgres --verbose | true
    ${HIVE_HOME}/bin/hive --service schematool -upgradeSchema -dbType postgres --verbose | true

    ${HIVE_HOME}/bin/hiveserver2

fi

if [ "${COMMAND}" == "metastore" ]; then

    echo "Starting Hive metastore ..."

    ${HIVE_HOME}/bin/hive --service schematool -initSchema -dbType postgres --verbose | true
    ${HIVE_HOME}/bin/hive --service schematool -upgradeSchema -dbType postgres --verbose | true
    
    ${HIVE_HOME}/bin/hive --service metastore

fi
