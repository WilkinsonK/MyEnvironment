#!/bin/bash


ENVIRONMENT_DIR=$1
ENVIRONMENT_NAME=$2
PROJECT_NAME=$3
PYTHON_EXECUTABLE=$4


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

ENVIRONMENT_LIB=$ENVIRONMENT_DIR/$ENVIRONMENT_NAME/lib
if [[ ! -d $ENVIRONMENT_LIB/site-packages ]]
then
    ENVIRONMENT_LIB=$ENVIRONMENT_LIB/$(ls $ENVIRONMENT_LIB | grep python3 | head -1)
fi


echo $ENVIRONMENT_DIR/$PROJECT_NAME > $ENVIRONMENT_LIB/site-packages/$PROJECT_NAME.pth
