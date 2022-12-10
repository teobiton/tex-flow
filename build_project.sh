#!/bin/bash

# Top script to setup a development environment.
# This script calls other script:
## - env_var.sh
## - setup_tree.sh

# Check if user has the required dependancies
echo "Checking dependancies:"

# git
echo -n "  checking if git is installed ... "
if command -v git >/dev/null 2>&1 ; then
    echo "yes"
else
    echo "no"
    echo "git not installed!"
    exit
fi

# make
echo -n "  checking if make is installed ... "
if command -v make >/dev/null 2>&1 ; then
    echo "yes"
else
    echo "no"
    echo "make not installed!"
    exit
fi

# texlive
echo -n "  checking if texlive is installed ... "
if command -v latex >/dev/null 2>&1 ; then
    echo "yes"
else
    echo "no"
    echo "latex not installed!"
    exit
fi

# java
echo -n "  checking if java is installed ... "
if command -v java >/dev/null 2>&1 ; then
    echo "yes"
else
    echo "no"
    echo "java not installed!"
    exit
fi

# texlive-bibtex-extra
echo -n "  checking if texlive-bibtex-extra is installed ... "
if command -v bib2gls >/dev/null 2>&1 ; then
    echo "yes"
else
    echo "no"
    echo "texlive-bibtex-extra not installed!"
    exit
fi

# Call env_var.sh
# Call setup_tree.sh