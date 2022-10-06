#!/bin/bash

# Here lies my bash snippets specifically for logical
# purposes. Technically, macros, or not unlike macros
# at the very least? Either way, writing in bash can
# get fairly abstract; hoping to make it less obtuse
# for the future.


exit 0


# IF..ELSE examples:
# https://linuxize.com/post/bash-if-else-statement/


# retrieve interactive input
# reading input examples:
# https://linuxize.com/post/bash-read/
echo -n "enter some value: "
read input_value


# handling a post execution of previous command,
# exit if exit code is other than a '0'.
exit_code=$?
if [[ $exit_code -ne 0 ]]
then
    echo "error occured. exiting."
    exit $exit_code
fi


# raise and exit if a target program does not exist,
# is not installed or is not on PATH.
# further examples in case this solution does not
# fit the needful, this example was derived from the
# below:
# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script

# in addition to the 'command' command, other
# options for testing a binary exists are
# 'which' or 'whereis'.
executable=python3
if [[ ! $(command -v $executable) ]]
then
    echo "${executable} not available. exiting."
    exit 2
fi


# raise and exit if a file does not exist.
file_location="~/tmp/junkfile.txt"
if [[ ! -f $file_location ]]
then
    echo "${file_location} either not a file or valid location. exiting."
    exit 1
fi


# raise and exit if a dir does not exist.
dir_location="~/tmp"
if [[ ! -d $dir_location ]]
then
    echo "${dir_location} either not a dir or valid location. exiting."
    exit 1
fi
