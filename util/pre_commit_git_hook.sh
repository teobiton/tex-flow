#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# To enable this hook, rename this file to "pre-commit".


## Linter TeX
# command taken from https://github.com/JLLeitschuh/ktlint-gradle  task addKtlintFormatGitPreCommitHook
filesToFormat="$(git --no-pager diff --name-status --no-color --cached | awk '$1 != "D" && $2 ~ /\.tex/ { print $NF}')"
# awk 
#		$1 is first collumn git output
#		$2 is path of file


for sourceFilePath in $filesToFormat
do
	echo "formatting $sourceFilePath"
    latexindent -w -s $sourceFilePath
# -w is overwrite
# -s is silence
	git add $sourceFilePath
done;
echo "Formatting complet"
