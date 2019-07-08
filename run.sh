#!/bin/bash

# the full path of this script
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# guest working directory
GUEST_BASE_DIR=/home/scala
# the name of the docker image to run
IMAGE=prlprg/oopsla19-scala
# the directory where to put all the stuff sbt will download
CACHE_DIR=cache
# actual cache directories
GLOBAL_IVY_DIR=$CACHE_DIR/ivy
GLOBAL_COURSIER_DIR=$CACHE_DIR/coursier
GLOBAL_SBT_DIR=$CACHE_DIR/sbt
GLOBAL_SBT_BOOT_DIR=$GLOBAL_SBT_DIR/boot

if [ $# -lt 1 ]; then
    echo "Usage: $0 <commands to run in the $IMAGE docker image>"
    exit 1
fi

if [ -z $GH_CLIENT_ID ]; then
    GH_CLIENT_ID=""
fi

if [ -z $GH_CLIENT_SECRET ]; then
    GH_CLIENT_SECRET=""
fi

[ -d $BASE_DIR/$GLOBAL_IVY_DIR ] || mkdir -p $BASE_DIR/$GLOBAL_IVY_DIR
[ -d $BASE_DIR/$GLOBAL_COURSIER_DIR ] || mkdir -p $BASE_DIR/{$GLOBAL_COURSIER_DIR,$GLOBAL_COURSIER_DIR/v1}
[ -d $BASE_DIR/$GLOBAL_SBT_DIR ] || mkdir -p $BASE_DIR/$GLOBAL_SBT_DIR
[ -d $BASE_DIR/$GLOBAL_SBT_BOOT_DIR ] || mkdir -p $BASE_DIR/$GLOBAL_SBT_BOOT_DIR

if [ -z "$WORKDIR" ]; then
    pwd="$(pwd)"
    WORKDIR=${pwd/$BASE_DIR/$GUEST_BASE_DIR}
fi

if [ -f "$BASE_DIR/$SBT_REPOSITORIES_FILE" ]; then
    SBT_REPOSITORIES_FILE="$GUEST_BASE_DIR/$SBT_REPOSITORIES_FILE"
    echo "Using SBT repositories file: $SBT_REPOSITORIES_FILE"
else
    SBT_REPOSITORIES_FILE=""
fi

if [[ ! $WORKDIR = $GUEST_BASE_DIR* ]]; then
    echo "This script computes a directory within the image where it shall run."
    echo "If the current directory is not child of the run.sh's enclosing dir, it won't work."
    echo "In this case, set WORKDIR"
    exit 1;
fi

docker run \
       --rm \
       -ti \
       -e GH_CLIENT_ID=$GH_CLIENT_ID \
       -e GH_CLIENT_SECRET=$GH_CLIENT_SECRET \
       -e GLOBAL_IVY_DIR=$GUEST_BASE_DIR/$GLOBAL_IVY_DIR \
       -e GLOBAL_COURSIER_DIR=$GUEST_BASE_DIR/$GLOBAL_COURSIER_DIR \
       -e GLOBAL_SBT_BOOT_DIR=$GUEST_BASE_DIR/$GLOBAL_SBT_BOOT_DIR \
       -e SBT_REPOSITORIES_FILE=$SBT_REPOSITORIES_FILE \
       -e HOST_USER_ID=$(id -u) \
       -e HOST_USER_GID=$(id -g) \
       -v $BASE_DIR/.git:$GUEST_BASE_DIR/.git \
       -v $BASE_DIR/$GLOBAL_IVY_DIR:$GUEST_BASE_DIR/.ivy2 \
       -v $BASE_DIR/$GLOBAL_SBT_DIR:$GUEST_BASE_DIR/.sbt \
       -v $BASE_DIR/$GLOBAL_SBT_BOOT_DIR:$GUEST_BASE_DIR/.sbt/boot \
       -v $BASE_DIR/$GLOBAL_COURSIER_DIR:$GUEST_BASE_DIR/.cache/coursier \
       -v $BASE_DIR/$CACHE_DIR:$GUEST_BASE_DIR/$CACHE_DIR \
       -v $BASE_DIR/scala-implicits-analysis:$GUEST_BASE_DIR/scala-implicits-analysis \
       -v $BASE_DIR/corpora:$GUEST_BASE_DIR/corpora \
       -w $WORKDIR \
       prlprg/oopsla19-scala \
       "$@"
