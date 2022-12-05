#!/bin/sh
# Script for set up

target_path="."

# Format Tex files automatically before commit
#   replace defaulf file <.git/pre_commit>
# TODO add 'if git repo in target_path'
cat $target_path/pre-commit.txt > .git/pre_commit