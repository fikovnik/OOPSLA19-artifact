#!/bin/bash

if [ -z "${USER}" ]; then
    echo "ERROR: USER environment variable need to be set!"
    exit 100
fi

USER_ID=${HOST_USER_ID:=$USER_ID}
USER_GID=${HOST_USER_GID:=$USER_GID}

# if both not set we do not need to do anything
if [ -z "${HOST_USER_ID}" -a -z "${HOST_USER_GID}" ]; then
    echo "WARN: Not using HOST_USER_ID and HOST_USER_GID."
    echo "WARN: This is not recommended as it likely lead to file permissions problems";
else
    groupmod -g ${USER_GID} ${USER}
    usermod -u ${USER_ID} -g ${USER_GID} ${USER}
fi

sudo -u "${USER}" \
     GH_CLIENT_ID=$GH_CLIENT_ID \
     GH_CLIENT_SECRET=$GH_CLIENT_SECRET \
     GLOBAL_IVY_DIR=$GLOBAL_IVY_DIR \
     GLOBAL_COURSIER_DIR=$GLOBAL_COURSIER_DIR \
     GLOBAL_SBT_BOOT_DIR=$GLOBAL_SBT_BOOT_DIR \
     SBT_REPOSITORIES_FILE=$SBT_REPOSITORIES_FILE \
     PATH=$PATH \
     JAVA_HOME=$JAVA_HOME \
     "$@"
