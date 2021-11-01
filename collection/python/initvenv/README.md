[initenv] [flags]

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
version numbered:                                     0.1.0
