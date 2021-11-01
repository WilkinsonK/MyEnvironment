#!/bin/bash

# Here lies cheats specific to, say, generic
# functionality that would/might be required
# when writing out a shell script.


exit 0


# get the working directory of the running
# script file.
# further examples as the following comes
# from this solution:
# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
