c-------------------------------------------------------------------------------
c
c     Equilibrium Helium Line Ratio Subroutine    
c
c     Authors : Jorge M. Munoz Burgos 
c     Auburn University / General Atomics    
c
c     Date : March 2013
c
c-------------------------------------------------------------------------------
      subroutine eqmodel(nexp,I_667exp,I_706exp,I_728exp, 
     &                   dI_667exp,dI_706exp,dI_728exp,
     &                   Te_out,Ne_out,dTe_out,dNe_out)
      implicit none

c-------------------------------------------------------------------------------
c  Type declarations - lengths of reals, integers, and complexes
c-------------------------------------------------------------------------------
      integer, parameter :: rprec = SELECTED_REAL_KIND(12,100)
      integer, parameter :: iprec = SELECTED_INT_KIND(12)
      integer, parameter :: rdprec = SELECTED_REAL_KIND(6,37)
      integer, parameter :: cprec = KIND((1.0_rprec,1.0_rprec))
                  
c-------------------------------------------------------------------------------
c  Other parameters
c-------------------------------------------------------------------------------
      real(rprec), parameter :: zero = 0.0_rprec
      real(rprec), parameter :: pzero = 1.0e-30_rprec
      real(rprec), parameter :: infinity = 1.0e+30_rprec
      real(rprec), parameter :: pi = 3.14159265358979323846264338328
      real(rprec), parameter :: twopi = 6.28318530717958647692528677

c-------------------------------------------------------------------------------
c  Atomic parameters
c-------------------------------------------------------------------------------
      real(rprec), parameter :: Aij_667_99 = 6.3705e+7_rprec
      real(rprec), parameter :: Aij_668_15 = 1.5100e+4_rprec
      real(rprec), parameter :: Aij_706_71 = 1.5474e+7_rprec
      real(rprec), parameter :: Aij_706_72 = 9.2844e+6_rprec
      real(rprec), parameter :: Aij_706_77 = 3.0948e+6_rprec
      real(rprec), parameter :: Aij_728_34 = 1.8299e+7_rprec

c-------------------------------------------------------------------------------
c  Uncertainties in the atomic model
c-------------------------------------------------------------------------------
      real(rprec), parameter :: dAij_667 = 
     &                          dsqrt(2.0_rprec*(0.01_rprec)**2)
      real(rprec), parameter :: dAij_706 =
     &                          dsqrt(3.0_rprec*(0.01_rprec)**2)
      real(rprec), parameter :: dAij_728 = 0.01_rprec
      real(rprec), parameter :: gamma_ij = 0.95_rprec
      real(rprec), parameter :: dNi = 0.05_rprec

      real(rprec), parameter :: dTeRm = dsqrt(dAij_706**2 + 
     &                                        dAij_728**2 +
     &               2.0_rprec*(1.0_rprec-gamma_ij)*dNi**2)   
      real(rprec), parameter :: dNeRm = dsqrt(dAij_667**2 + 
     &                                        dAij_728**2 +
     &               2.0_rprec*(1.0_rprec-gamma_ij)*dNi**2)   
      real(rprec), parameter :: dTeNeRm = dsqrt(dAij_706**2 + 
     &                                          dAij_667**2 +
     &                 2.0_rprec*(1.0_rprec-gamma_ij)*dNi**2)   

c-------------------------------------------------------------------------------
c  Smoothing parameters
c-------------------------------------------------------------------------------
      real(rprec), parameter :: intpar = 1.0e+7_rprec

c-------------------------------------------------------------------------------
c  Line ratio parameters for the input files
c-------------------------------------------------------------------------------
      integer(iprec), parameter :: nTe = 210_iprec
      integer(iprec), parameter :: nNe = 135_iprec

c-------------------------------------------------------------------------------
c  Input/output variables
c-------------------------------------------------------------------------------
      integer(iprec), intent(in) :: nexp
      real(rprec), dimension(nexp), intent(in) :: I_667exp, I_706exp
      real(rprec), dimension(nexp), intent(in) :: I_728exp, dI_667exp
      real(rprec), dimension(nexp), intent(in) :: dI_706exp, dI_728exp
      real(rprec), dimension(nexp), intent(out) :: Te_out, Ne_out
      real(rprec), dimension(nexp,2), intent(out) :: dTe_out, dNe_out

c-------------------------------------------------------------------------------
c  Variables declaration
c-------------------------------------------------------------------------------
      real(rprec), dimension(nexp) :: I_667, I_706, I_728
      real(rprec), dimension(nexp) :: dI_667, dI_706, dI_728
      real(rprec), dimension(nexp) :: TeRexp, NeRexp, TeNeRexp
      real(rprec), dimension(nexp) :: dTeRexp, dNeRexp, dTeNeRexp
      real(rprec), dimension(nexp) :: Te_exp, Ne_exp
      real(rprec), dimension(nexp,2) :: dTe_exp, dNe_exp

c-------------------------------------------------------------------------------
c-- processing variables ------------------------------------------------------- 
c-------------------------------------------------------------------------------
      logical :: ex, op
      integer(iprec) :: n, i
      integer(iprec) :: ntemp, ndens
      real(rprec) :: x

      real(rprec) :: Te(nTe), Ne(nNe)     
      real(rprec) :: TeR(nTe,nNe), NeR(nTe,nNe), TeNeR(nTe,nNe)
      real(rprec) :: dTeRtot, dNeRtot, dTeNeRtot
      
      real(rprec) :: min, min_p, min_m
      real(rprec) :: chisqrt, chisq_p, chisq_m
      integer(iprec) :: indx_Te, indx_Ne 
      integer(iprec) :: indx_Tep, indx_Nep, indx_Tem, indx_Nem

      real(rprec) :: Vmag, K1, K2
      real(rprec) :: Xvec(3), Yvec(3), Vn1(3), Vn2(3)

c-------------------------------------------------------------------------------
c  Executes the subroutine
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c   Opens equilibrium data files
c-------------------------------------------------------------------------------
      ex = .false.
      op = .false.
      inquire(file='eqmodel/Te_Ratio.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(10,file='eqmodel/Te_Ratio.dat')   
      else
         write(*,*) 'ERROR, no Te_Ratio input file found'
	 stop
      endif	 

      ex = .false.
      op = .false.
      inquire(file='eqmodel/Ne_Ratio.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(20,file='eqmodel/Ne_Ratio.dat')   
      else
         write(*,*) 'ERROR, no Ne_Ratio input file found'
	 stop
      endif	 

      ex = .false.
      op = .false.
      inquire(file='eqmodel/TeNe_Ratio.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(30,file='eqmodel/TeNe_Ratio.dat')   
      else
         write(*,*) 'ERROR, no TeNe_Ratio input file found'
	 stop
      endif	 

c-------------------------------------------------------------------------------
c   Reads Te and Ne equilibrium data
c-------------------------------------------------------------------------------
      read(10,*) x, Ne(1:nNe)
      do n = 1,nTe
         read(10,*) Te(n), TeR(n,1:nNe)
      enddo	 
      close(10) 
      
      read(20,*)
      do n = 1,nTe
         read(20,*) x, NeR(n,1:nNe)
      enddo	
      close(20) 
      
      read(30,*)
      do n = 1,nTe
         read(30,*) x, TeNeR(n,1:nNe)
      enddo	
      close(30) 

c-------------------------------------------------------------------------------
      do n = 1,nexp
	 I_667(n) = abs(I_667exp(n))
	 I_706(n) = abs(I_706exp(n))
	 I_728(n) = abs(I_728exp(n))
	 dI_667(n) = abs(dI_667exp(n))
	 dI_706(n) = abs(dI_706exp(n))
	 dI_728(n) = abs(dI_728exp(n))

         TeRexp(n) = I_706(n)/I_728(n)
         NeRexp(n) = I_667(n)/I_728(n)
	 TeNeRexp(n) = I_706(n)/I_667(n)

         dTeRexp(n) = TeRexp(n)*dsqrt((dI_706(n)/I_706(n))**2 +
     &                                (dI_728(n)/I_728(n))**2)
         dNeRexp(n) = NeRexp(n)*dsqrt((dI_667(n)/I_667(n))**2 +
     &                                (dI_728(n)/I_728(n))**2)
         dTeNeRexp(n) = TeNeRexp(n)*
     &	                dsqrt((dI_706(n)/I_706(n))**2 +
     &                        (dI_667(n)/I_667(n))**2)

      enddo
      
c-------------------------------------------------------------------------------
c  Calculates the experimental Te and Ne values using the equilibrium model
c-------------------------------------------------------------------------------
      do n = 1,nexp
         min = infinity
	 min_p = infinity
	 min_m = infinity

         do ntemp = 2,nTe-1
	    do ndens = 2,nNe-1
               dTeRtot = dsqrt((dTeRm*TeR(ntemp,ndens))**2 +
     &	                                       dTeRexp(n)**2) 	       
               dNeRtot = dsqrt((dNeRm*NeR(ntemp,ndens))**2 +
     &	                                       dNeRexp(n)**2) 	       
               dTeNeRtot = dsqrt((dTeNeRm*TeNeR(ntemp,ndens))**2 +
     &	                                           dTeNeRexp(n)**2) 	       
	      
               chisqrt = (1.0_rprec-TeRexp(n)/TeR(ntemp,ndens))**2 +  
     &                   (1.0_rprec-NeRexp(n)/NeR(ntemp,ndens))**2 +
     &                   (1.0_rprec-TeNeRexp(n)/TeNeR(ntemp,ndens))**2
               if(chisqrt .lt. min) then
	          min = chisqrt
		  indx_Te = ntemp
		  indx_Ne = ndens
	       endif
	       
               chisq_p = (1.0_rprec-(TeRexp(n)+dTeRtot)/ 
     &	                            TeR(ntemp,ndens))**2 +  
     &                   (1.0_rprec-(NeRexp(n)+dNeRtot)/ 
     &                              NeR(ntemp,ndens))**2 +
     &                   (1.0_rprec-(TeNeRexp(n)+dTeNeRtot)/ 
     &                              TeNeR(ntemp,ndens))**2
               if(chisq_p .lt. min_p) then
	          min_p = chisq_p
		  indx_Tep = ntemp
		  indx_Nep = ndens
	       endif

               chisq_m = (1.0_rprec-(TeRexp(n)-dTeRtot)/ 
     &	                            TeR(ntemp,ndens))**2 +  
     &                   (1.0_rprec-(NeRexp(n)-dNeRtot)/ 
     &                              NeR(ntemp,ndens))**2 +
     &                   (1.0_rprec-(TeNeRexp(n)-dTeNeRtot)/ 
     &                              TeNeR(ntemp,ndens))**2
               if(chisq_m .lt. min_m) then
	          min_m = chisq_m
		  indx_Tem = ntemp
		  indx_Nem = ndens
	       endif
            enddo
	 enddo
	 
c-------------------------------------------------------------------------------
c  Interpolates the Te and Ne values using the equilibrium model
c-------------------------------------------------------------------------------
         Xvec(1) = Te(indx_Te+1) - Te(indx_Te-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*TeR(indx_Te+1,indx_Ne))- 
     &             dlog10(intpar*TeR(indx_Te-1,indx_Ne))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Ne+1)) - dlog10(Ne(indx_Ne-1))
         Yvec(3) = dlog10(intpar*TeR(indx_Te,indx_Ne+1))- 
     &             dlog10(intpar*TeR(indx_Te,indx_Ne-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Te(indx_Te+1) - Te(indx_Te-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeR(indx_Te+1,indx_Ne))- 
     &             dlog10(intpar*NeR(indx_Te-1,indx_Ne))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Ne+1)) - dlog10(Ne(indx_Ne-1))
         Yvec(3) = dlog10(intpar*NeR(indx_Te,indx_Ne+1))- 
     &             dlog10(intpar*NeR(indx_Te,indx_Ne-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*TeRexp(n))-  
     &                dlog10(intpar*TeR(indx_Te,indx_Ne)))
         K2 = Vn2(3)*(dlog10(intpar*NeRexp(n))-  
     &                dlog10(intpar*NeR(indx_Te,indx_Ne)))


         Te_exp(n) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	             (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2))+ 
     &               Te(indx_Te) 

         Ne_exp(n) = -(Vn2(1)*(Te_exp(n)-Te(indx_Te))+K2)/Vn2(2)+ 
     &               dlog10(Ne(indx_Ne))
         Ne_exp(n) = (10.0e+0_rprec)**Ne_exp(n)		  		  

         Te_exp(n) = abs(Te_exp(n))
         Ne_exp(n) = abs(Ne_exp(n))

         if(Te_exp(n) .gt. Te(nTe)) then
            Te_exp(n) = Te(nTe)
         endif
         if((Te_exp(n) .lt. Te(1)) .or. (isnan(Te_exp(n)))) then
            Te_exp(n) = Te(1)
         endif

         if(Ne_exp(n) .gt. Ne(nNe)) then
            Ne_exp(n) = Ne(nNe)
         endif
         if((Ne_exp(n) .lt. Ne(1)) .or. (isnan(Ne_exp(n)))) then
            Ne_exp(n) = Ne(1)
         endif

         Te_out(n) = Te_exp(n)
         Ne_out(n) = Ne_exp(n)
	 
c-------------------------------------------------------------------------------
c  Interpolates the Te and Ne uncertainty values using the equilibrium model
c-------------------------------------------------------------------------------
         dTeRtot = dsqrt((dTeRm*TeR(indx_Tep,indx_Nep))**2 +
     &	                                       dTeRexp(n)**2) 	       
         dNeRtot = dsqrt((dNeRm*NeR(indx_Tep,indx_Nep))**2 +
     &	                                       dNeRexp(n)**2) 	       
         dTeNeRtot = dsqrt((dTeNeRm*TeNeR(indx_Tep,indx_Nep))**2 +
     &	                                           dTeNeRexp(n)**2) 	       

         Xvec(1) = Te(indx_Tep+1) - Te(indx_Tep-1)
         Xvec(2) = 0.0e+0_rprec
         Xvec(3) = dlog10(intpar*TeR(indx_Tep+1,indx_Nep))- 
     &             dlog10(intpar*TeR(indx_Tep-1,indx_Nep))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Nep+1)) - dlog10(Ne(indx_Nep-1))
         Yvec(3) = dlog10(intpar*TeR(indx_Tep,indx_Nep+1))- 
     &             dlog10(intpar*TeR(indx_Tep,indx_Nep-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Te(indx_Tep+1) - Te(indx_Tep-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeR(indx_Tep+1,indx_Nep))- 
     &             dlog10(intpar*NeR(indx_Tep-1,indx_Nep))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Nep+1)) - dlog10(Ne(indx_Nep-1))
         Yvec(3) = dlog10(intpar*NeR(indx_Tep,indx_Nep+1))- 
     &             dlog10(intpar*NeR(indx_Tep,indx_Nep-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*(TeRexp(n)+dTeRtot))-  
     &                dlog10(intpar*TeR(indx_Tep,indx_Nep)))
         K2 = Vn2(3)*(dlog10(intpar*(NeRexp(n)+dNeRtot))-  
     &                dlog10(intpar*NeR(indx_Tep,indx_Nep)))


         dTe_exp(n,2) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	                (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2))+ 
     &                  Te(indx_Tep) 

         dNe_exp(n,1) = -(Vn2(1)*(dTe_exp(n,2)-Te(indx_Tep))+K2)/Vn2(2)+ 
     &                  dlog10(Ne(indx_Nep))
         dNe_exp(n,1) = (10.0e+0_rprec)**dNe_exp(n,1)		  		  

         dTe_exp(n,2) = abs(dTe_exp(n,2))
         dNe_exp(n,1) = abs(dNe_exp(n,1))

         if(dTe_exp(n,2) .gt. Te(nTe)) then
            dTe_exp(n,2) = Te(nTe)
         endif
         if(dTe_exp(n,2) .lt. Te(1)) then
            dTe_exp(n,2) = Te(1)
         endif

         if(dNe_exp(n,1) .gt. Ne(nNe)) then
            dNe_exp(n,1) = Ne(nNe)
         endif
         if(dNe_exp(n,1) .lt. Ne(1)) then
            dNe_exp(n,1) = Ne(1)
         endif

         dTe_exp(n,2) = abs(Te_exp(n)-dTe_exp(n,2))
         dNe_exp(n,1) = abs(Ne_exp(n)-dNe_exp(n,1))

	 if(isnan(dTe_exp(n,2))) then
	    dTe_exp(n,2) = 0.0_rprec
	 endif    
	 if(isnan(dNe_exp(n,1))) then
	    dNe_exp(n,1) = 0.0_rprec
	 endif    

         dTe_out(n,2) = dTe_exp(n,2)
         dNe_out(n,1) = dNe_exp(n,1)

c-------------------------------------------------------------------------------
         dTeRtot = dsqrt((dTeRm*TeR(indx_Tem,indx_Nem))**2 +
     &	                                       dTeRexp(n)**2) 	       
         dNeRtot = dsqrt((dNeRm*NeR(indx_Tem,indx_Nem))**2 +
     &	                                       dNeRexp(n)**2) 	       
         dTeNeRtot = dsqrt((dTeNeRm*TeNeR(indx_Tem,indx_Nem))**2 +
     &	                                           dTeNeRexp(n)**2) 	       

         Xvec(1) = Te(indx_Tem+1) - Te(indx_Tem-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*TeR(indx_Tem+1,indx_Nem))- 
     &             dlog10(intpar*TeR(indx_Tem-1,indx_Nem))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Nem+1)) - dlog10(Ne(indx_Nem-1))
         Yvec(3) = dlog10(intpar*TeR(indx_Tem,indx_Nem+1))- 
     &             dlog10(intpar*TeR(indx_Tem,indx_Nem-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Te(indx_Tem+1) - Te(indx_Tem-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeR(indx_Tem+1,indx_Nem))- 
     &             dlog10(intpar*NeR(indx_Tem-1,indx_Nem))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Ne(indx_Nem+1)) - dlog10(Ne(indx_Nem-1))
         Yvec(3) = dlog10(intpar*NeR(indx_Tem,indx_Nem+1))- 
     &             dlog10(intpar*NeR(indx_Tem,indx_Nem-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*(TeRexp(n)-dTeRtot))-  
     &                dlog10(intpar*TeR(indx_Tem,indx_Nem)))
         K2 = Vn2(3)*(dlog10(intpar*(NeRexp(n)-dNeRtot))-  
     &                dlog10(intpar*NeR(indx_Tem,indx_Nem)))


         dTe_exp(n,1) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	                (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2))+ 
     &                  Te(indx_Tem) 

         dNe_exp(n,2) = -(Vn2(1)*(dTe_exp(n,1)-Te(indx_Tem))+K2)/Vn2(2)+ 
     &                  dlog10(Ne(indx_Nem))
         dNe_exp(n,2) = (10.0e+0_rprec)**dNe_exp(n,2)		  		  

         dTe_exp(n,1) = abs(dTe_exp(n,1))
         dNe_exp(n,2) = abs(dNe_exp(n,2))

         if(dTe_exp(n,1) .gt. Te(nTe)) then
            dTe_exp(n,1) = Te(nTe)
         endif
         if(dTe_exp(n,1) .lt. Te(1)) then
            dTe_exp(n,1) = Te(1)
         endif

         if(dNe_exp(n,2) .gt. Ne(nNe)) then
            dNe_exp(n,2) = Ne(nNe)
         endif
         if(dNe_exp(n,2) .lt. Ne(1)) then
            dNe_exp(n,2) = Ne(1)
         endif

         dTe_exp(n,1) = abs(Te_exp(n)-dTe_exp(n,1))
         dNe_exp(n,2) = abs(Ne_exp(n)-dNe_exp(n,2))
	 
	 if(isnan(dTe_exp(n,1))) then
	    dTe_exp(n,1) = 0.0_rprec
	 endif    
	 if(isnan(dNe_exp(n,2))) then
	    dNe_exp(n,2) = 0.0_rprec
	 endif    

         dTe_out(n,1) = dTe_exp(n,1)
         dNe_out(n,2) = dNe_exp(n,2)

      enddo

c-------------------------------------------------------------------------------
c  End of subroutine
c-------------------------------------------------------------------------------
      end subroutine eqmodel

c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
