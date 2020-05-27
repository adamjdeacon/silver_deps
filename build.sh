#! /bin/bash

PKGNAME=${PKGNAME=`cat DESCRIPTION  | grep Package: | awk {'print $2'}`}
R -e "install.packages('remotes')"

R -e "remotes::install_deps(\".\", dependencies = TRUE, upgrade=\"never\", threads = parallel::detectCores())"

echo "Building the Package (${PKGNAME})"
if ! R CMD build . ; then
  echo "Build Failed"
  exit 1
fi

tarfile=$(ls ${PKGNAME}*.tar.gz)

echo "Running CMD check"
R CMD check $tarfile --no-manual

checkdir=$(ls -d ${PKGNAME}.Rcheck)

status=$(cat $checkdir/00check.log | grep "^Status")

echo $status

if grep -q "ERROR\|WARNING" <<< $status; then
  echo $status 1>&2
  echo "Check Failed" 1>&2
  exit 1
else
  exit 0
fi


