#/bin/bash

# build a virtual environment in the
# present working directory of execution.


PYTHON_EXECUTABLE=/usr/local/bin/python3.10
PYTHON_VENV_ENGINE=venv
PYTHON_VENV_NAME=".venv"


echo "building environment"
$PYTHON_EXECUTABLE -m $PYTHON_VENV_ENGINE $PYTHON_VENV_NAME
source $(pwd)/$PYTHON_VENV_NAME/bin/activate && \
    pip install wheel &&                        \
    pip install -r requirements.txt
