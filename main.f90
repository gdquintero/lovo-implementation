Program main
    use sort

    implicit none 
    
    integer :: allocerr,iter,intIter,predictedDays,i,j,r,i4_choose,vk,dimImin
    integer, parameter :: n = 3,maxIter = 1000,maxIntIter = 1000,nzMaxImin = 10
    real, parameter :: alpha = 0.5d0,epsilon = 1.0d-7
    real(kind=8), allocatable :: sk(:),xk(:),xtrial(:),dFmin(:),faux(:),gaux(:),indices(:)
    real(kind=8) :: lambda,fxk,fxtrial,aux,optCond,sigma

    ! COMMON SCALARS
    integer :: m,q

    ! COMMON ARRAYS
    integer,        pointer :: t(:)
    real(kind=8),   pointer :: y(:)

    ! COMMON BLOCKS
    common /integerData/ m,q
    common /integerVectorData/ t
    common /realVectorData/ y

    ! LINKED LIST OF INTEGERS
    type integerValue
        integer :: iteration, value
        type(integerValue), pointer :: next
    end type integerValue

    ! type(integerValue), pointer :: head,tail,counter
    ! nullify(head,tail,counter)

    ! Set parameters
    Open(Unit = 200, File = "output/days.txt", ACCESS = "SEQUENTIAL")
    read(200,*) m
    read(200,*) q
    read(200,*) predictedDays
    close(200)

    q = m - q 
    
    allocate(sk(n),xk(n),xtrial(n),dFmin(n),stat=allocerr)
    allocate(t(m),y(m),indices(m),stat=allocerr)
    allocate(faux(m),gaux(n),stat=allocerr)

    if ( allocerr .ne. 0 ) then
        write(*,*) 'Allocation error in main program'
        stop
    end if

    call readData()

    iter = 0
    xk(1:n) = 0.0d0
    
    ! call mountFmin(fxk,indices,xk,n,faux)

    print*, i4_choose(5,3)
    
    call export(xk,n,y(m),m,predictedDays)

    CONTAINS

    !==============================================================================
    ! EXPORT RESULT TO PLOT
    !==============================================================================
    subroutine export(x,n,x1,ntrain,nval)
        implicit none

        integer,        intent(in) :: n,ntrain,nval
        real(kind=8),   intent(in) :: x(n),x1
        real(kind=8) :: aux
        integer :: i,j

        Open(Unit = 100, File = "output/gnuplot/xstarlovo.txt", ACCESS = "SEQUENTIAL")
        Open(Unit = 110, File = "output/gnuplot/training.txt", ACCESS = "SEQUENTIAL")
        Open(Unit = 120, File = "output/gnuplot/validation.txt", ACCESS = "SEQUENTIAL")
        Open(Unit = 130, File = "output/data.txt", ACCESS = "SEQUENTIAL")
        Open(Unit = 140, File = "output/data2.txt", ACCESS = "SEQUENTIAL")

        write(100,*) x1
        write(100,*) x(1)
        write(100,*) x(2)
        write(100,*) x(3)

        do i = 1, ntrain
            read(130,*) aux
            write(110,*) i, aux
        enddo

        j = i

        do i = 1, nval
            read(140,*) aux
            write(120,*) j, aux
            j = j + 1
        enddo
        
        close(100)

    end subroutine export

    !==============================================================================
    !
    !==============================================================================
    subroutine mountFmin(fx,indices,x,n,faux)
        implicit none

        integer,        intent(in) :: n
        real(kind=8),   intent(in) :: x(n)
        real(kind=8),   intent(inout) :: faux(m)
        real(kind=8),   intent(out) :: fx,indices(m)
        integer :: i,kflag

        ! COMMON SCALARS
        integer :: m,q

        ! COMMON ARRAYS
        integer,        pointer :: t(:)
        real(kind=8),   pointer :: y(:)

        common /integerData/ m,q
        common /integerVectorData/ t
        common /realVectorData/ y

        faux(1:m) = 0.0d0
        kflag = 2

        indices(:) = (/(i, i = 1, m)/)

        do i = 1, m
            faux(i) = fi(x,i,n)
        enddo

        ! Sorting all the functions with Quicksort
        call DSORT(faux,indices,m,kflag)

        ! p-LOVO function
        fx = sum(faux(1:q))

    end subroutine mountFmin

    subroutine mountGrad(dFmin,x,n,indices)
        implicit none

        integer,        intent(in) :: n,indices(q)
        real(kind=8),   intent(in) :: x(n)
        real(kind=8),   intent(out) :: dFmin(n)
        integer :: i,j
        real(kind=8) :: gx

        ! COMMON SCALARS
        integer :: m,p,q

        ! COMMON ARRAYS
        integer,        pointer :: t(:)
        real(kind=8),   pointer :: y(:)

        common /integerData/ m,q
        common /integerVectorData/ t
        common /realVectorData/ y

        dFmin(1:n) = 0.0d0
                
        do j = 1, q
            gx = (model(x,indices(j),n) - y(indices(j)))
            dFmin(1:n) = dFmin(1:n) + gx * (/((t(indices(j)) - t(m))**i, i = 1, n)/)
        enddo

    end subroutine mountGrad

    function fi(x,i,n) result (res)
        implicit none

        integer,        intent(in) :: n,i
        real(kind=8),   intent(in) :: x(n)
        real(kind=8) :: res
        integer :: k

        ! COMMON SCALARS
        integer :: m,q

        ! COMMON ARRAYS
        integer,        pointer :: t(:)
        real(kind=8),   pointer :: y(:)

        common /integerData/ m,q
        common /integerVectorData/ t
        common /realVectorData/ y
        
        res = model(x,i,n) - y(i)
        res = 0.5d0 * (res**2)

    end function fi

    function model(x,i,n) result(res)
        implicit none 

        integer,        intent(in) :: n,i
        real(kind=8),   intent(in) :: x(n)
        real(kind=8) :: res
        integer :: k

        ! COMMON SCALARS
        integer :: m,q

        ! COMMON ARRAYS
        integer,        pointer :: t(:)
        real(kind=8),   pointer :: y(:)

        common /integerData/ m,q
        common /integerVectorData/ t
        common /realVectorData/ y

        res = dot_product(x,(/((t(i) - t(m))**k, k = 1, n)/))
        res = res + y(m)

    end function model

    !==============================================================================
    ! READ THE DATA CORRESPONDING TO THE NUMBER OF days DESIRED
    !==============================================================================
    subroutine readData()
        implicit none

        ! COMMON SCALARS
        integer :: m,q

        ! COMMON ARRAYS
        integer,        pointer :: t(:)
        real(kind=8),   pointer :: y(:)

        ! COMMON BLOCKS
        common /integerData/ m,q
        common /integerVectorData/ t
        common /realVectorData/ y

        ! SCALARS
        integer :: i, j = 1
        real(kind=8) :: dat

        t(:) = (/(i,i = 1, m)/)

        Open(Unit = 20, File = "output/data.txt", ACCESS = "SEQUENTIAL")

        do i = 1, m
            read(20,*) dat

            if (i .ge. 1) then
                y(j) = dat
                j = j + 1
            endif
        enddo

        close(20)
    end subroutine readData

    subroutine append(new,iter,head,tail)
        implicit none

        type(integerValue), pointer, intent(inout) :: head,tail
        integer, intent(in) :: iter,new

        if (.not. associated(head)) then
            allocate(head)
            tail => head
            nullify(tail%next)
            tail%value = new
            tail%iteration = iter
        else
            allocate(tail%next)
            tail => tail%next
            nullify(tail%next)
            tail%value = new
            tail%iteration = iter
        endif
    end subroutine append
end Program main