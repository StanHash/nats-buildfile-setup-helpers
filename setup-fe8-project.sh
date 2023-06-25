#!/bin/bash

# usage: ./setup-fe8-project.sh path/to/new/project path/to/fireemblem8u

if [[ -z "${1}" || -z ${2} ]]
then
  echo "Usage: ${0} path/to/new/project path/to/fireemblem8u"
  exit 1
fi

here=$(dirname "$(readlink -f "${0}")")
target=$(readlink -f "${1}")
fe8=$(readlink -f "${2}")

echo "I am here: ${here}"
echo "Setting up: ${target}"
echo "Getting fe8 from: ${fe8}"

read -p "Is that ok (y/N)?" -r

if [[ !($REPLY =~ ^[Yy]$) ]]
then
  echo "Take your time."
  exit 1
fi

echo "Copying files..."
cp -f  ${here}/.gitignore ${target}/.gitignore
cp -f  ${here}/.clang-format ${target}/.clang-format
cp -f  ${here}/Makefile.fe8 ${target}/Makefile
cp -fr ${here}/tools ${target}/
rm -f ${target}/tools/gen-fe6-clib.sh
touch ${target}/main.event
echo "Done."

echo "Getting event assembler..."
${target}/tools/get-event-assembler.sh || (echo "Failed to get event assembler"; exit 2)
echo "Done."

echo "Generating fe8 clib..."
${target}/tools/gen-fe8-clib.sh ${fe8} || (echo "Failed to generate clib"; exit 2)
echo "Done."

echo "base rom located at ${1}/tools/fe8_us.gba"
