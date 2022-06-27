rm -f ov-functions

gfortran -fcheck=all -g ov-functions.f90 sort.o -o ov-functions

./ov-functions