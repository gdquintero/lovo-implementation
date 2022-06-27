rm -f order-values

gfortran -fcheck=all -g order-values.f90 sort.o -o order-values

./order-values