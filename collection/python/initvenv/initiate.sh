#!/bin/bash

ENVIRONMENT_DIR=$1
ENVIRONMENT_NAME=$2
PYTHON_EXECUTABLE=$3
PYTHON_INDEX=$4


# ensure the python executable does exists.
if [[ ! $(command -v $PYTHON_EXECUTABLE) ]]
then
    echo "${PYTHON_EXECUTABLE} missing or not on PATH. exiting."
    exit 2
fi

# ensure target environment dir exists.
if [[ ! -d $ENVIRONMENT_DIR ]]
then
    echo "${ENVIRONMENT_DIR} not a valid location. exiting."
    exit 1
fi


exit_on_failure() {
    exit_code=$1
    if [[ $exit_code -ne 0 ]]
    then
        exit $exit_code
    fi
}


# build the environment.
if [[ ! -d $ENVIRONMENT_DIR/$ENVIRONMENT_NAME ]]
then
    echo "building base environment"
    $PYTHON_EXECUTABLE -m venv $ENVIRONMENT_DIR/$ENVIRONMENT_NAME
    exit_on_failure $?
fi


ENVIRONMENT_BIN=$ENVIRONMENT_DIR/$ENVIRONMENT_NAME/bin
exec_in_venv() {
    source $ENVIRONMENT_BIN/activate \
        && $@                        \
        && deactivate
    exit_on_failure $?
}


# update pip to latest version.
exec_in_venv              \
    pip install           \
    --upgrade pip         \
    --index $PYTHON_INDEX


# install wheel as preliminary dependency.
exec_in_venv              \
    pip install           \
    wheel                 \
    --index $PYTHON_INDEX


# install wheel as preliminary dependency.
exec_in_venv              \
    pip install           \
    poetry                \
    --index $PYTHON_INDEX
