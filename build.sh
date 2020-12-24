#!/bin/bash

set -x
set -e

# originally found here https://superuser.com/a/1560067

docker build -t invertpdf .

# can be used from the container as follows, if java isn't installed

# docker run -it --rm -v "$(pwd)":/invertpdf -w /invertpdf invertpdf "$1" "$2" '#343d46'

# otherwise the jar can be run directly

id="$(docker run -it -d --entrypoint sh invertpdf)"
docker cp $id:/PDFInverter/build/libs/PDFInverter.jar PDFInverter.jar
docker stop $id
