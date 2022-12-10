#!/bin/sh

# This file creates the working tree from the template

# if $INSTALL_DIR is empty
if [ -z "$INSTALL_DIR" ]
then
      echo "ERROR: \$INSTALL_DIR is empty, make sure to execute 'make install' in the install dir before\n"
      # for development setup export INSTALL_DIR=<path>
      exit
fi

# if the report folder already exists
if [ -d "report" ]
then
      echo "ERROR: report directory already exists\n"
      exit
fi

# copy report folder with tempate
cp -r $INSTALL_DIR $(pwd)
