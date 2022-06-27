program orderValueFunctions
    use sort
    
    implicit none
    
    real*8 :: h,a,b
    integer :: n,i,j,kflag
    real*8, allocatable :: grid(:),scenario(:,:),aux(:),indices(:),orderValue(:,:)

    n = 100
    a = 1.0d0
    b = 5.0d0
    h = (b - a) / (n + 1)
    kflag = 1

    allocate(grid(n+2),aux(5),indices(5),scenario(5,n+2),orderValue(5,n+2))

    indices(:) = (/(i, i = 1, 5)/)

    do i = 1, n + 2
        grid(i) = a + (i - 1) * h
        scenario(1,i) = func1(grid(i))
        scenario(2,i) = func2(grid(i))
        scenario(3,i) = func3(grid(i))
        scenario(4,i) = func4(grid(i))
        scenario(5,i) = func5(grid(i))
    end do

    call export(grid,scenario,n)

    do j = 1, n + 2
        do i = 1, 5
            aux(i) = scenario(i,j)
        end do
        call DSORT(aux,indices,5,kflag)
        orderValue(1,j) = aux(1)
        orderValue(2,j) = aux(5)
    end do

    contains

    subroutine export(grid,scenario,n)
        implicit none

        integer, intent(in) :: n
        real*8, intent(in) :: grid(n+2),scenario(5,n+2)
        integer :: i

        Open(Unit = 100, File = "output/gnuplot/scenarios.txt", ACCESS = "SEQUENTIAL")
        Open(Unit = 110, File = "output/gnuplot/ov-functions.txt", ACCESS = "SEQUENTIAL")

        do i = 1, n+2
            write(100,*) grid(i), scenario(1,i), scenario(2,i), scenario(3,i), scenario(4,i), scenario(5,i)
        end do

    end subroutine

    function func1(x) result (res)
        implicit none 

        real*8, intent(in) :: x
        real*8 :: res

        res = sin(x)
    end function

    function func2(x) result (res)
        implicit none 

        real*8, intent(in) :: x
        real*8 :: res

        res = cos(x)
    end function

    function func3(x) result (res)
        implicit none 

        real*8, intent(in) :: x
        real*8 :: res

        res = (2.0d0 / 3.0d0) * log(x + 0.5d0)
    end function

    function func4(x) result (res)
        implicit none 

        real*8, intent(in) :: x
        real*8 :: res

        res = (1.0d0 / 20.0d0) * (x - 4.0d0)**2
        res = res + 0.5d0
    end function

    function func5(x) result (res)
        implicit none 

        real*8, intent(in) :: x
        real*8 :: res

        res = cos(2.0d0 * x)
    end function

end program orderValueFunctions 