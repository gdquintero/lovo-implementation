module combination

    contains

    subroutine comb_unrank(m,n,rank,a)

        !*****************************************************************************80
        !
        !! COMB_UNRANK returns the RANK-th combination of N things out of M.
        !
        !  Discussion:
        !
        !    Going from a rank to a thing is called "unranking".
        !
        !    The combinations are ordered lexically.
        !
        !    Lexical order can be illustrated for the general case of N and M as
        !    follows:
        !
        !    1:       1,     2,     3,     ..., N-2, N-1, N
        !    2:       1,     2,     3,     ..., N-2, N-1, N+1
        !    3:       1,     2,     3,     ..., N-2, N-1, N+2
        !    ...
        !    M-N+1:   1,     2,     3,     ..., N-2, N-1, M
        !    M-N+2:   1,     2,     3,     ..., N-2, N,   N+1
        !    M-N+3:   1,     2,     3,     ..., N-2, N,   N+2
        !    ...
        !    LAST-2:  M-N,   M-N+1, M-N+3, ..., M-2, M-1, M
        !    LAST-1:  M-N,   M-N+2, M-N+3, ..., M-2, M-1, M
        !    LAST:    M-N+1, M-N+2, M-N+3, ..., M-2, M-1, M
        !
        !    There are a total of M!/(N!*(M-N)!) combinations of M
        !    things taken N at a time.
        !
        !  Licensing:
        !
        !    This code is distributed under the GNU LGPL license.
        !
        !  Modified:
        !
        !    02 December 2008
        !
        !  Author:
        !
        !    John Burkardt
        !
        !  Reference:
        !
        !    Bill Buckles, Matthew Lybanon,
        !    Algorithm 515:
        !    Generation of a Vector from the Lexicographical Index,
        !    ACM Transactions on Mathematical Software,
        !    Volume 3, Number 2, pages 180-182, June 1977.
        !
        !    David Crouse,
        !    Remark on Algorithm 515,
        !    ACM Transactions on Mathematical Software,
        !    Volume 33, Number 2, Article 15, June 2007.
        !
        !  Parameters:
        !
        !    Input, integer M, the size of the set.
        !
        !    Input, integer N, the number of things in the combination.
        !    N must be greater than 0, and no greater than M.
        !
        !    Input, integer RANK, the lexicographical rank of the
        !    combination sought.  RANK must be at least 1, and no greater
        !    than M!/(N!*(M-N)!).
        !
        !    Output, integer A(N), the combination.
        implicit none

        integer, parameter :: rk = kind ( 1.0D+00 )

        integer n

        integer a(n)
        integer i
        integer i4_choose
        integer j
        integer k
        integer m
        integer rank

        if ( n < 0 ) then
        return
        else if ( n == 0 ) then
        a(1) = rank
        return
        end if
        !
        !  Initialize the lower bound index.
        !
        k = 0
        !
        !  Select elements in ascending order.
        !
        do i = 1, n - 1
        !
        !  Set the lower bound element number for next element value.
        !
        a(i) = 0

        if ( 1 < i ) then
            a(i) = a(i-1)
        end if
        !
        !  Check each element value.
        !
        do

            a(i) = a(i) + 1
            j = binomialCoef ( m-a(i), n-i )
            k = k + j

            if ( rank <= k ) then
            exit
            end if

        end do

        k = k - j

        end do

        a(n) = a(n-1) + rank - k

        return
    end subroutine comb_unrank

    recursive function binomialCoef(n,k) result(res)
        implicit none

        integer, intent(in) :: n,k
        integer :: res 

        if (k .gt. n) then
            res = 0
        elseif (k .eq. 0 .or. k .eq. n) then
            res = 1
        else
            res = binomialCoef(n - 1,k - 1) + binomialCoef(n - 1,k)
        endif

    end function binomialCoef
end module