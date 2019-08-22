module Collier_wrapper
   use COLLIER
   use, intrinsic :: iso_c_binding
   use, intrinsic :: iso_fortran_env
   implicit none

contains

   function C00(p10, p21, p20, m02, m12, m22, scl2) result(res) bind(C, name='C00_cll')

      ! inputs and output from this function
      ! we use the c++ equivalent type names from the iso_c_binding module
      complex(C_DOUBLE_COMPLEX), intent(in) :: p10, p21, p20
      complex(C_DOUBLE_COMPLEX), intent(in) :: m02, m12, m22
      real(C_DOUBLE), intent(in) :: scl2
      complex(C_DOUBLE_COMPLEX) :: res

      complex(REAL64), allocatable :: Ccoeff(:,:,:), Ccoeffuv(:,:,:)
      integer, parameter :: rank = 3

      call Init_cll(3)
      call SetMuUV2_cll(scl2)

      allocate(Ccoeff(0:rank/2, 0:rank, 0:rank))
      allocate(Ccoeffuv(0:rank/2, 0:rank, 0:rank))

      call C_cll(Ccoeff, Ccoeffuv, p10, p21, p20, m02, m12, m22, rank)

      res = Ccoeff(1,0,0)

      deallocate(Ccoeff, Ccoeffuv)
   end
end module
