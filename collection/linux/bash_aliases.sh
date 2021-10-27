
# python shortcuts
if [[ $DEFAULT_PYTHON = "" ]]
then
    DEFAULT_PYTHON=python3
fi

alias py=$DEFAULT_PYTHON
alias pi='${DEFAULT_PYTHON} -i'

# ls aliases; just in case not included
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
