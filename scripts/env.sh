#!/bin/bash

export PROJECT_ROOT=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))

export SOURCE_ROOT=$PROJECT_ROOT/src
export OBJECT_ROOT=$PROJECT_ROOT/obj
export BINARY_ROOT=$PROJECT_ROOT/bin

export BUILD=$PROJECT_ROOT/build
export SCRIPTS=$PROJECT_ROOT/scripts

echo "PROJECT_ROOT = $PROJECT_ROOT"
echo " SOURCE_ROOT = $SOURCE_ROOT"
echo " OBJECT_ROOT = $OBJECT_ROOT"
echo " BINARY_ROOT = $BINARY_ROOT"
echo "       BUILD = $BUILD"
echo "     SCRIPTS = $SCRIPTS"
