#! /bin/bash
#
gfortran -c sort.f90
if [ $? -ne 0 ]; then
  echo "Compile error."
  exit
fi
#
# mv subset.o ~/lib/subset.o
#
echo "Normal end of execution."