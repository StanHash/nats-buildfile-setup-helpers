#!/bin/bash

# usage: ./gen-fe8-clib.sh path/to/fireemblem8u

if [[ -z "${1}" ]]
then
  echo "Usage: ${0} path/to/fireemblem8u"
  echo "Make sure fireemblem8.elf exists (should be if last build was successful)"
  exit 1
fi

here=$(dirname "$(readlink -f "${0}")")
fe8=$(readlink -f "${1}")

rm -fr ${here}/clib
mkdir -p ${here}/clib
python "${here}/scripts/elf2ref.py" "${fe8}/fireemblem8.elf" > ${here}/clib/fe8_us.s
python "${here}/scripts/elf2sym.py" "${fe8}/fireemblem8.elf" > ${here}/clib/fe8_us.sym
cp -fr ${fe8}/include ${here}/clib

# since we have a build fe8 anyway, we can get fireemblem8.gba here too
cp -f ${fe8}/fireemblem8.gba ${here}/fe8_us.gba
