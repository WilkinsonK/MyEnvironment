#!/bin/bash


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


if [[ $1 == "--help" ]]
then
    cat $SCRIPT_DIR/README.md
    exit 0
fi


# declare script constants.
ENVIRONMENT_DIR=$(pwd)
ENVIRONMENT_NAME=.venv
PROJECT_NAME=project


# allow constant override from shell
# from select flags.
index=${index:-"https://pypi.org/simple"}
pyexe=${pyexe:-python3}

while [ $# -gt 0 ]
do
    if [[ $1 == *"--"* ]]
    then
        param="${1/--/}"
        declare $param=$2
    fi
    shift
done

PYTHON_EXECUTABLE=$pyexe
PYTHON_INDEX=$index


# allow for constants override through
# interactive prompt.
env_basename=$(basename "${ENVIRONMENT_DIR}")
echo -n "venv location [../${env_basename}]: "
read read_in
if [[ $read_in ]]
then
    ENVIRONMENT_DIR=$read_in
fi


# if constants.sh file exists in environment
# location, load constants from there. otherwise,
# allow for overrides interactively.
echo -n "venv name [${ENVIRONMENT_NAME}]: "
read read_in
if [[ $read_in ]]
then
    ENVIRONMENT_NAME=$read_in
fi

echo -n "project name [${PROJECT_NAME}]: "
read read_in
if [[ $read_in ]]
then
    PROJECT_NAME=$read_in
fi


exit_on_failure() {
    exit_code=$1
    if [[ $exit_code -ne 0 ]]
    then
        echo "error occured. exiting."
        exit $exit_code
    fi
}


# execute the build scripts if it exists,
# otherwise skip this step.
if [[ -f $SCRIPT_DIR/initiate.sh ]]
then
    $SCRIPT_DIR/initiate.sh \
        $ENVIRONMENT_DIR    \
        $ENVIRONMENT_NAME   \
        $PYTHON_EXECUTABLE  \
        $PYTHON_INDEX
    exit_on_failure $?
fi


if [[ -f $SCRIPT_DIR/build.sh ]]
then
    $SCRIPT_DIR/build.sh  \
        $ENVIRONMENT_DIR  \
        $ENVIRONMENT_NAME \
        $PYTHON_INDEX     \
        $PROJECT_NAME
    exit_on_failure $?
fi


if [[ -f $SCRIPT_DIR/finalize.sh ]]
then
    $SCRIPT_DIR/finalize.sh  \
        $ENVIRONMENT_DIR     \
        $ENVIRONMENT_NAME    \
        $PROJECT_NAME        \
        $PYTHON_EXECUTABLE
    exit_on_failure $?
fi


echo "complete."
