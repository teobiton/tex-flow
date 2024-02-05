#!/bin/sh
# Script for set up

# if $INSTALL_DIR is empty
if [ -z "$INSTALL_DIR" ]
then
      echo "ERROR: \$INSTALL_DIR is empty, make sure to execute 'make install' in the install dir before\n"
      # for development setup export INSTALL_DIR=<path>
      exit
fi

git init

## setup hooks

# Format Tex files automatically before commit
#   replace defaulf file <.git/pre_commit>
# TODO add 'if git repo in target_path'
cat $INSTALL_DIR/pre_commit_git_hook.sh > .git/hooks/pre-commit