    
  !----------------------------------------------------------------------------
  subroutine SSPRK_marching_2D(q,rk,dtt)
  use MD2D_Grid
  use Legendre
use RK_Var

  implicit none
    integer:: rk,q
    real(kind=8):: dtt

    if (q .lt. rk) then  
       F_new = F_new + alpha(q+1)*(F_alt+dtt*F_t)
       F_alt = F_alt + dtt*F_t
    else
       F_new = F_new + alpha(rk)*dtt*F_t
    endif
!    write(6,*) "F_t",F_t(1:3,1,0:2,0:2,3)
  end subroutine SSPRK_marching_2D
  !------------------------------------------------------------------------------
  subroutine RK4s5_marching_2D_kinetic(q,rk,dtt)
    !--Declare subroutine arguments
  use MD2D_Grid
  use Legendre
use RK_Var

    implicit none
    integer:: rk,q
    real(kind=8):: dtt

    
     F_new = RK_para_a(q)*F_new+ dtt*F_t
     F_alt = F_alt + RK_para_b(q)*F_new

!     q_tmp(0:N1) = RK_para_a(ks)*q_tmp(0:N1) &
!                          + dt*dqdt(0:N1,0:N2)    
!     q(0:N1,0:N2) = q(0:N1,0:N2) &
!                          + RK_para_b(ks)*q_tmp(0:N1,0:N2) 
    
    
    return
    !
  end subroutine RK4s5_marching_2D_kinetic

!=====================================================================

  subroutine ERK_marching_2D(l,dt_rk)
    use State_Var
    use RK_Var
    use Legendre
    implicit none
!    integer:: nnx ,pp ,l,K
    integer:: l
    real(kind=8):: dt_rk
! Local Variables
    integer:: i,j

! F_new F at the next time-step  <=> F_new(1D)
! F_alt F at the new stage F_alt(2D) <=> F(1D)

    if (l .LT. RK_Stage) then

     F_new=F_new+ dt_rk*const_b(l)*(F_s(:,:,:,:,:,l)+F_ns(:,:,:,:,:,l))
     F_alt=Fold
      do j=1,l
       F_alt = F_alt + dt_rk*(const_a_I(l+1,j)*F_s(:,:,:,:,:,j) + &
          const_a_E(l+1,j)*F_ns(:,:,:,:,:,j))
      enddo
    else
       F_new=F_new+ dt_rk*const_b(l)*(F_s(:,:,:,:,:,l)+F_ns(:,:,:,:,:,l))
    endif

  end subroutine ERK_marching_2D

  !------------------------------------------------------------------------------
  subroutine ARK_marching_2D(l,dt_rk)
    use State_Var
    use RK_Var
    use Legendre
    implicit none
    integer:: l
    real(kind=8):: dt_rk
! Local Variables
    integer:: i,j

! F_new F at the next time-step  <=> F_new(1D)
! F_alt F at the new stage F_alt(2D) <=> F(1D)

    if (l .LT. RK_Stage) then

     F_new=F_new+ dt_rk*const_b(l)*(F_s(:,:,:,:,:,l)+F_ns(:,:,:,:,:,l))
     F_alt=Fold
      do j=1,l
       F_alt = F_alt + dt_rk*(const_a_I(l+1,j)*F_s(:,:,:,:,:,j) + &
          const_a_E(l+1,j)*F_ns(:,:,:,:,:,j))
      enddo
    else
       F_new=F_new+ dt_rk*const_b(l)*(F_s(:,:,:,:,:,l)+F_ns(:,:,:,:,:,l))
    endif

  end subroutine ARK_marching_2D

  !------------------------------------------------------------------------------
