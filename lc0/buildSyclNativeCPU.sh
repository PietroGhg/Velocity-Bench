#    This file is part of Leela Chess Zero.
#    Modifications Copyright (C) 2023 Intel Corporation
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#    SPDX-License-Identifier: GNU General Public License v3.0 only








#!/usr/bin/env bash

pushd "$(dirname "$0")"

set -e

case $1 in
  plain|debug|debugoptimized|release|minsize)
    BUILDTYPE=$1
    shift
    ;;
  *)
    BUILDTYPE=release
    ;;
esac

BUILDDIR=build_nativecpu/${BUILDTYPE}

#if ! hash meson 2>/dev/null && [ -x ${HOME}/.local/bin/meson ]
#then
#  export PATH=${PATH}:${HOME}/.local/bin
#fi

if [ -f ${BUILDDIR}/build.ninja ]
then
  meson configure ${BUILDDIR} -DUSE_AMD=false -DUSE_SYCL=true -DUSE_CUDA=false -Dbuildtype=${BUILDTYPE} -Dprefix=${INSTALL_PREFIX:-/usr/local} "$@" 
else
  meson ${BUILDDIR} --buildtype ${BUILDTYPE} -DUSE_AMD=false -DUSE_SYCL=true -DUSE_CUDA=false --prefix ${INSTALL_PREFIX:-/usr/local} "$@"
fi

cd ${BUILDDIR}

#NINJA=$(awk '/ninja/ {ninja=$4} END {print ninja}' meson-logs/meson-log.txt)
NINJA=`which ninja`

if [ -n "${INSTALL_PREFIX}" ]
then
  ${NINJA} install
else
  ${NINJA} --verbose
fi

popd
