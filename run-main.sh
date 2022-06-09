rm -f main

gfortran -fcheck=all -g main.f90 sort.o -o main

./main
