#!/bin/bash

# Author: Keenan W. Wilkinson
# From his private library, found at:
# https://github.com/WilkinsonK/environment-collections/blob/main/collection/python/install_from_source.sh

# Use this script to pull and build a python
# distribution from the source code. Effectively
# this is an install wizard to make a future
# install easier.

# script constants
BUILD_THREAD_COUNT=16
OVERRIDE_PYTHON3_CMD="Y"
PYTHON_SOURCE_VERSION="3.8.6"
PYTHON_BUILD_DIR=$(pwd)/python

echo "begin building python from source"

# allow for user defined variables
echo -n "enter the desired version [${PYTHON_SOURCE_VERSION}]: "
read python_source_version

echo -n "use as target for 'python3'? [Y/n]: "
read override_python3_cmd

if [[ $python_source_version != "" ]]
then
    PYTHON_SOURCE_VERSION=$python_source_version
elif [[ $1 != "" ]]
then
    PYTHON_SOURCE_VERSION=$1
fi

if [[ $override_python3_cmd != "" ]]
then
    override_python3_cmd=${override_python3_cmd^^}
    if [[ $override_python3_cmd = "Y" || $override_python3_cmd = "N" ]]
    then
        OVERRIDE_PYTHON3_CMD=$override_python3_cmd
    else
        echo "was given unexpected input other than 'Y' or 'N'"
        exit "1"
    fi
fi

# ensure dependencies installed
echo "updating needed binaries"
DEBIAN_FRONTEND=noninteractive TZ=Etx/UTC apt-get -y install tzdata
apt-get install -y   \
    make             \
    build-essential  \
    libssl-dev       \
    zlib1g-dev       \
    libbz2-dev       \
    libreadline-dev  \
    libsqlite3-dev   \
    wget             \
    curl             \
    llvm             \
    libncurses5-dev  \
    libncursesw5-dev \
    xz-utils         \
    tk-dev           \

if [[ $? -ne 0 ]]
then
    exit $?
fi


# download necessary files
echo "downloading source files"
wget -P $PYTHON_BUILD_DIR https://www.python.org/ftp/python/${PYTHON_SOURCE_VERSION}/Python-${PYTHON_SOURCE_VERSION}.tgz
if [[ $? -ne 0 ]]
then
    exit $?
fi

tar -C $PYTHON_BUILD_DIR -xvf ${PYTHON_BUILD_DIR}/Python-${PYTHON_SOURCE_VERSION}.tgz
if [[ $? -ne 0 ]]
then
    exit $?
fi


# ensure configuration
echo "setting configuration"
cd ${PYTHON_BUILD_DIR}/Python-${PYTHON_SOURCE_VERSION} && ./configure \
    --enable-optimizations                                    \
    --with-ensurepip=install
if [[ $? -ne 0 ]]
then
    exit $?
fi


# make and install from source
echo "begin install"
make -j $BUILD_THREAD_COUNT
if [[ $? -ne 0 ]]
then
    exit $?
fi

if [[ $OVERRIDE_PYTHON3_CMD = "Y" ]]
then
    make install
else
    make altinstall
fi

cd ..
rm -rf ${PYTHON_BUILD_DIR}
