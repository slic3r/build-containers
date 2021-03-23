#!/usr/bin/env bash
mkdir -p /build/slic3r
cd /build/slic3r
cmake -DCMAKE_PREFIX_PATH=${1}/destdir/usr/local -DSLIC3R_STATIC=1 /source
make -j4 Slic3r
