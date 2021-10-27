#!/bin/bash


if [[ $1 == "--help" ]]
then
    echo \
"[initenv] [--flags]

Initialize the virtual environment for the following python
project.

NOTE: This is a quick and dirty shell script with no flag,
type or parameter validation included so please be mindful
of how it is mean to be used.

flags:
    --help      print this message and exit.
    --index     target python index to use for dependencies.
    --pyexe     target python executable to use.

Using the optional flags above, the user will be walked
through a series of questions interactively. Afterwards,
a virtual environment will be generated from the present
working directory with dependencies installed including a
pth file pointing to the project source directory.

authored by:                            Keenan W. Wilkinson
version '0' created on:                          10-26-2021
version numbered:                                     0.0.0
"
    exit 0
fi


# script constants.
ENVIRONMENT_DIR=$(pwd)
ENVIRONMENT_NAME=.venv
SOURCE_FILE_LOC=project


# override flags.
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

DEFAULT_PYTHON=$pyexe
REQUIREMENT_INDEX=$index


# allow for constants override.
echo -n "venv location [${ENVIRONMENT_DIR}]: "
read environment_dir

if [[ $environment_dir != "" ]]
then
    ENVIRONMENT_DIR=$environment_dir
fi

echo -n "venv name [${ENVIRONMENT_NAME}]: "
read environment_name

if [[ $environment_name != "" ]]
then
    ENVIRONMENT_NAME=$environment_name
fi

echo -n "source files location [$SOURCE_FILE_LOC]: "
read source_file_loc

if [[ $source_file_loc != "" ]]
then
    SOURCE_FILE_LOC=$source_file_loc
fi


# variables dependant on constants.
requirements_file=$ENVIRONMENT_DIR/requirements.txt
vsrc_root=$ENVIRONMENT_DIR/$SOURCE_FILE_LOC
venv_root=$ENVIRONMENT_DIR/$ENVIRONMENT_NAME
venv_bin=$venv_root/bin


# build the environment.
echo "building environment"
if [[ ! -d $venv_root ]]
then
    $DEFAULT_PYTHON -m venv $venv_root
fi

exit_code=$?
if [[ $exit_code -ne 0 ]]
then
    echo "error occured. exiting."
    exit $exit_code
fi


# Windows likes to be different from everyone else
# and instead uses a slightly different dir scheme.
if [[ -d $venv_root/Scripts ]]
then
    venv_bin=$venv_root/Scripts
fi

# update pip.
source $venv_bin/activate          \
    && pip install                 \
        --upgrade pip              \
        --index $REQUIREMENT_INDEX \
    && deactivate

# install wheel as preliminary dependency.
source $venv_bin/activate          \
    && pip install                 \
        wheel                      \
        --index $REQUIREMENT_INDEX \
    && deactivate

exit_code=$?
if [[ $exit_code -ne 0 ]]
then
    echo "error occured. exiting."
    exit $exit_code
fi


# install dependencies from requirements_file
# if the target file exists in working directory.
echo $REQUIREMENT_INDEX
if [[ -f $requirements_file ]]
then
    echo "requirements file detected."
    echo "installing dependencies..."
    source $venv_bin/activate     \
        && pip install            \
            -r $requirements_file \
            -i $REQUIREMENT_INDEX \
        && deactivate

    exit_code=$?
    if [[ $exit_code -ne 0 ]]
    then
        echo "error occured. exiting."
        exit $exit_code
    fi
fi

# create a pth file within venv site-packages dir
# to include project source files in python path.
if [[ ! -d $vsrc_root ]]
then
    mkdir $vsrc_root
fi

if [[ -d $venv_root/lib/site-packages ]]
then
    pth_file_loc=$venv_root/lib/site-packages
else 
    # fallback in case site-packages path is not
    # immediately available.
    pth_file_loc=$venv_root/lib
fi
echo $vsrc_root > $pth_file_loc/project.pth
