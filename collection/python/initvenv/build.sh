#!/bin/bash


ENVIRONMENT_DIR=$1
ENVIRONMENT_NAME=$2
PYTHON_INDEX=$3
PROJECT_NAME=$4


exit_on_failure() {
    exit_code=$1
    if [[ $exit_code -ne 0 ]]
    then
        exit $exit_code
    fi
}


ENVIRONMENT_BIN=$ENVIRONMENT_DIR/$ENVIRONMENT_NAME/bin
exec_in_venv() {
    source $ENVIRONMENT_BIN/activate \
        && $@                        \
        && deactivate
    exit_on_failure $?
}


PROJECT_DIR=$ENVIRONMENT_DIR/$PROJECT_NAME
if [[ ! -d $PROJECT_DIR ]]
then
    mkdir $PROJECT_DIR
fi


if [[ ! -f $ENVIRONMENT_DIR/pyproject.toml ]]
then
    echo "no project file present."
    echo "building project from scratch."
    exec_in_venv poetry init
fi


echo "installing dependencies..."
exec_in_venv poetry install -n
exec_in_venv poetry lock
