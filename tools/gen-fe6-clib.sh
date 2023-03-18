#!/bin/bash

# usage: ./gen-fe6-clib.sh path/to/fe6

if [[ -z "${1}" ]]
then
  echo "Usage: ${0} path/to/fe6"
  echo "Make sure fe6.elf exists (should be if last build was successful)"
  exit 1
fi

here=$(dirname "$(readlink -f "${0}")")
fe6=$(readlink -f "${1}")

rm -fr ${here}/clib
mkdir -p ${here}/clib
python "${here}/scripts/elf2ref.py" "${fe6}/fe6.elf" > ${here}/clib/fe6.s
python "${here}/scripts/elf2sym.py" "${fe6}/fe6.elf" > ${here}/clib/fe6.sym
cp -fr ${fe6}/include ${here}/clib

# since we have a build fe6 anyway, we can get fe6.gba here too
cp -f ${fe6}/fe6.gba ${here}/fe6.gba
