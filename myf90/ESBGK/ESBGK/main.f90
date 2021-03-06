! A Discontinuous Galerkin implementation for
! Semiclassical Botlzmann ES-BGK for one-dimensional space.
!
! coded and modified by,
! Manuel Diaz, NTU, 2013.07.13
! f99543083'at'.ntu.edu.tw
!
program main
    ! Load modules
    use mathmodule          ! linear Algebra functions
    use dispmodule          ! matlab display function for arrays
    use tecplotmodule       ! write to tecplot functions
    use quadraturemodule    ! Gauss Hermite and Newton cotes abscissas and weights
    use initmodule          ! load 1d initial condition to algorithm

    ! No implicit variables allowed
    implicit none

    ! Governing Parameters
    integer, parameter  :: mo = 2       ! ooa in space
    integer, parameter  :: mt = 2       ! ooa in time
    integer, parameter  :: quad = 2     ! 1: GH, 2: NC
    integer, parameter  :: ic = 1       ! Initial Condition, see: initmodule
    integer, parameter  :: kflux = 1    ! 1: Roe, 2: LF, 3: LLF
    real, parameter     :: tend = 0.2   ! terminal time
    real, parameter     :: cfl = 0.5    ! CFL Number
    real, parameter     :: tau = 0.001  ! Relaxation Time
    real, parameter     :: MM = 1       ! TVB constant M

    ! Quadrature Parameters / Velocity space points
      ! Gauss Hermite Quadrature (GH)
      integer, parameter :: ngh = 10    ! GH points (actual number of points)
      ! Newton Cotes Quadrature (NC)
      integer, parameter :: nnc = 10    ! NC points (desired number of points)
      integer, parameter :: nodes = 4   ! Number of nodes for NC formula (degree)
      integer, parameter :: nnc_real = 1 + (nodes-1)*ceiling(real(nnc)/(nodes-1))
                                        ! NC points (the actual number of points)
      ! Quadrature weight and abscissas
      real :: k                         ! quadrature constant
      real, allocatable  :: w(:),nv(:)  ! Size will depend on the choose quadrature

    ! Grid and IC Arrays
    integer, parameter  :: nx=20,ny=20  ! XY-grid size
    real :: rl,ul,pl,rr,ur,pr           ! left and right IC values

    ! Probability Distritubion Function Arrays
    real :: f,feq,f_next  ! Matrix Arrays
    real :: x   !Vector arrays
    integer :: idnumber,np
    !character(len = 100) :: output_file = 'myresults.plt'
    !character(len = 100) :: output_file2 = 'myresults.plt'
    real :: T1, T2, T3  ! Computation times

    ! Calculate CPU time
    call cpu_time(T1);

    Print *, 'Build Nv points using Selected Aquadrature method'; print *, ' ';
    select case (quad)
        case (1)
            ! allocate w and nv
            allocate( w(ngh) ); allocate( nv(ngh) );
            ! compute w and nv
            call gauss_hermite(ngh,nv,w); k = 1.0;
            ! add factor e^(x^2) to weights
            w = w*exp(nv*nv)
            ! Print message
            print *, 'Number of GH points to be used: ',ngh; print *, ' ';
        case (2)
            ! allocate w and nv
            allocate( w(nnc_real) ); allocate( nv(nnc_real) );
            ! compute w and nv
            call newton_cotes(-2.0,2.0,nnc_real,nodes,nv,w,k)
            ! Print message
            print *, 'Number of NC points to be used',nnc_real; print *, ' ';
        case default
            print *, 'quadrature not available'
    end select

    ! Chek point (uncomment to diplay variables)
    !call disp('nv = ',nv); print *, ' ';
    !call disp('w = ',w); print *, ' ';
    !call disp('k = ',k); print *, ' ';

    print *, 'Build Grid and Load initial condition (IC)'; print *, ' ';
    call Initial_Condition(ic,rl,ul,pl,rr,ur,pr)

    ! Chek point (uncomment to diplay variables)
    call disp(' (rho,u,p) at the left  = ',reshape((/rl,ul,pl/),(/1,3/))  )
    call disp(' (rho,u,p) at the right = ',reshape((/rr,ur,pr/),(/1,3/))  )
    print *, ' ';



    ! write to tecplot file
    !call tecplot_write_open(output_file,idnumber) ! open output file and identified No.
        print *, ' '
        !print *, 'Opening output file with id No.: ',idnumber
    !call tecplot_write_header(idnumber,'Line data','"X","Y"') ! write header.
        print *, ' '
        print *, 'Writing the Tecplot header'
    !call tecplot_write_xy_line(idnumber,np,x,y) ! write data to file
        print *, ' '
        print *, 'Write data "X","Y" to file'
    !call tecplot_write_close(idnumber) ! close file
        print *, ' '
        !print *, 'Number of data point writen was: ',np

    ! Calculate CPU Time
    call cpu_time(T2)
    print *, 'time to write file', T2-T1, 'seconds.'

end program main
