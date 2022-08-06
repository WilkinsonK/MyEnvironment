#!/bin/bash

set -eu

# Writes the project directory to a *.pth file located in the
# lowest available site-packages folder.
echo $(pwd)/project > $(python3 -c "import site; print(site.getsitepackages()[-1])")/project-path.pth
exit 0
