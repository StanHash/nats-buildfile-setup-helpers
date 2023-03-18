#!/bin/bash

# usage: ./setup-fe6-project.sh path/to/new/project path/to/fe6

if [[ -z "${1}" || -z ${2} ]]
then
  echo "Usage: ${0} path/to/new/project path/to/fe6"
  exit 1
fi

here=$(dirname "$(readlink -f "${0}")")
target=$(readlink -f "${1}")
fe6=$(readlink -f "${2}")

echo "I am here: ${here}"
echo "Setting up: ${target}"
echo "Getting fe6 from: ${fe6}"

read -p "Is that ok (y/N)?" -r

if [[ !($REPLY =~ ^[Yy]$) ]]
then
  echo "Take your time."
  exit 1
fi

echo "Copying files..."
cp -f  ${here}/.gitignore ${target}/.gitignore
cp -f  ${here}/.clang-format ${target}/.clang-format
cp -f  ${here}/Makefile.fe6 ${target}/Makefile
cp -fr ${here}/tools ${target}/
touch ${target}/main.event
echo "Done."

echo "Getting event assembler..."
${target}/tools/get-event-assembler.sh || (echo "Failed to get event assembler"; exit 2)
echo "Done."

echo "Generating fe6 clib..."
${target}/tools/gen-fe6-clib.sh ${fe6} || (echo "Failed to generate clib"; exit 2)
echo "Done."

echo "base rom located at ${1}/tools/fe6.gba"
