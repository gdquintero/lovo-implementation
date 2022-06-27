program orderValueFunctions
    implicit none
    
    real*8 :: h,a,b
    integer :: n,i
    real*8, allocatable :: grid(:),scenario(:,:)

    n = 3
    h = 1.0d0 / (n + 1)
    a = 0.0d0
    b = 1.0d0

    allocate(grid(n+2),scenario(5,n+2))

    do i = 1, n + 2
        grid(i) = a + (i - 1) * h
        scenario(1,i) = func1(grid(i))
        scenario(2,i) = func2(grid(i))
        scenario(3,i) = func3(grid(i))
        scenario(4,i) = func4(grid(i))
        scenario(5,i) = func5(grid(i))
    end do


    Open(Unit = 100, File = "output/gnuplot/scenario-functions.txt", ACCESS = "SEQUENTIAL")
    Open(Unit = 110, File = "output/gnuplot/ov-functions.txt", ACCESS = "SEQUENTIAL")


    contains

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