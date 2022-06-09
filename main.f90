Program main
    use sort

    implicit none 
    
    integer :: allocerr,iter,intIter,predictedDays,i,j,r,i4_choose,vk,dimImin,percent
    integer, parameter :: n = 3,maxIter = 100000,maxIntIter = 1000,nzMaxImin = 10
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
    percent = 1
    xk(1:n) = 0.0d0
    
    call mountFmin(fxk,indices,xk,n,faux)

    do
        iter = iter + 1
        call mountGrad(dFmin,xk,n,int(indices(1:q)))

        sigma = 1.0d0
        intIter = 0

        do  
            intIter = intIter + 1
            sk(1:n) = (-1.0d0 / sigma) * dFmin(1:n)
            xtrial(1:n) = xk(1:n) + sk(1:n)

            call mountFmin(fxtrial,indices,xtrial,n,faux)

            if (fxtrial .lt. (fxk - alpha * norm2(sk)**2)) exit
            if (intIter .ge. maxIntIter) exit  

            sigma = 2.0d0 * sigma
        enddo
        
        ! optCond = norm2(dFmin)
        optCond = norm2(xk(1:n) - xtrial(1:n))
        xk(1:n) = xtrial(1:n)
        fxk = fxtrial   

        print*, optCond

        ! if (iter .eq. percent * (maxIter / 100)) then
        !     print*, percent,'%'
        !     percent = percent + 1
        ! endif
        
        if (iter .ge. maxIter .or. optCond .le. epsilon) exit        
    enddo

    
    call export(xk,n,y(m))

    CONTAINS

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
    ! EXPORT RESULT TO PLOT
    !==============================================================================
    subroutine export(x,n,x1)
        implicit none

        integer,        intent(in) :: n
        real(kind=8),   intent(in) :: x(n),x1

        Open(Unit = 30, File = "output/xstarlovo.txt", ACCESS = "SEQUENTIAL")

        write(30,*) x1
        write(30,*) x(1)
        write(30,*) x(2)
        write(30,*) x(3)
        
        close(30)

    end subroutine export

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