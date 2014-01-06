c-------------------------------------------------------------------------------
c
c     Time-Dependent Helium Line Ratio Subroutine    
c
c     Authors : Jorge M. Munoz Burgos 
c     Auburn University / General Atomics    
c
c     Date : March 2013
c
c-------------------------------------------------------------------------------
      subroutine tdmodel(nexp,vb,ro,radius,I_667exp,I_706exp,I_728exp, 
     &                                  dI_667exp,dI_706exp,dI_728exp,
     &                                  Te_out,Ne_out,dTe_out,dNe_out)
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
      real(rprec), parameter :: wt_1s_3s_3S1 = 3.0_rprec
      real(rprec), parameter :: wt_1s_3s_1S0 = 1.0_rprec
      real(rprec), parameter :: wt_1s_3d_1D2 = 5.0_rprec
      real(rprec), parameter :: wt_1s_3d_3D2 = 5.0_rprec
      real(rprec), parameter :: totwt_1s_3s_3S = 3.0_rprec
      real(rprec), parameter :: totwt_1s_3s_1S = 1.0_rprec
      real(rprec), parameter :: totwt_1s_3d_1D = 5.0_rprec
      real(rprec), parameter :: totwt_1s_3d_3D = 15.0_rprec

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
c  Ion beam parameters
c-------------------------------------------------------------------------------
      integer(iprec), parameter :: nTet = 125_iprec
      integer(iprec), parameter :: nNet = 76_iprec
      integer(iprec), parameter :: nmtrx = 19_iprec
      real(rprec), dimension(nmtrx), parameter :: Noi = (/
     & 1.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec, 
     & 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec,
     & 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec,
     & 0.0_rprec, 0.0_rprec, 0.0_rprec, 0.0_rprec/)                                   

c-------------------------------------------------------------------------------
c  Smoothing parameters
c-------------------------------------------------------------------------------
      real(rprec), parameter :: intpar = 1.0e+7_rprec
                            
c-------------------------------------------------------------------------------
c  Input/output variables
c-------------------------------------------------------------------------------
      integer(iprec), intent(in) :: nexp
      real(rprec), intent(in) :: vb, ro
      real(rprec), dimension(nexp), intent(in) :: radius
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
      real(rprec), dimension(nexp) :: Tet_exp, Net_exp
      real(rprec), dimension(nexp,2) :: dTet_exp, dNet_exp

c-------------------------------------------------------------------------------
c-- processing variables ------------------------------------------------------- 
c-------------------------------------------------------------------------------
      logical :: ex, op
      integer(iprec) :: i, j, k, m, n
      integer(iprec) :: ntemp, ndens
      real(rprec) :: x, t, ri

      real(rprec) :: Tet(nTet), Net(nNet)     
      real(rprec) :: TeRt(nTet,nNet), NeRt(nTet,nNet), TeNeRt(nTet,nNet)
      real(rprec) :: No(nmtrx), Nt(nmtrx,nTet,nNet), Xv(nmtrx)
      real(rprec) :: Yv(nmtrx,nmtrx)      
      real(rprec) :: exps(nmtrx), recv(nmtrx,nmtrx)
      real(rprec) :: VRmtr(nmtrx,nmtrx), VRinv(nmtrx,nmtrx)      

      real(rprec) :: Nein(nNet*nmtrx), Datain(nNet*nmtrx)     
      real(rprec) :: lamda(nTet,nNet,nmtrx) 
      real(rprec) :: Rvect(nTet,nNet,nmtrx,nmtrx)     
      real(rprec) :: VM(nTet,nNet,nmtrx,nmtrx)
      real(rprec) :: VI(nTet,nNet,nmtrx,nmtrx)
      
      real(rprec) :: I_667_99, I_668_15 
      real(rprec) :: I_706_71, I_706_72, I_706_77, I_728_34
      real(rprec) :: dTeRtot, dNeRtot, dTeNeRtot
      
      real(rprec) :: min, min_p, min_m
      real(rprec) :: chisqrt, chisq_p, chisq_m
      integer(iprec) :: indx_Te, indx_Ne 
      integer(iprec) :: indx_Tep, indx_Nep, indx_Tem, indx_Nem

      real(rprec) :: Vmag, K1, K2
      real(rprec) :: Xvec(3), Yvec(3), Vn1(3), Vn2(3)
      real(rprec) :: xi(2), yi(2), xj, yj

c-------------------------------------------------------------------------------
c  Executes the subroutine
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c   Opens time dependent data files
c-------------------------------------------------------------------------------
      ex = .false.
      op = .false.
      inquire(file='tdmodel/Eigenval.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(40,file='tdmodel/Eigenval.dat')   
      else
         write(*,*) 'ERROR, no Eigenval input file found'
	 stop
      endif	 

      ex = .false.
      op = .false.
      inquire(file='tdmodel/Recvec.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(50,file='tdmodel/Recvec.dat')   
      else
         write(*,*) 'ERROR, no Recvec input file found'
	 stop
      endif	 

      ex = .false.
      op = .false.
      inquire(file='tdmodel/Vmtrx.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(60,file='tdmodel/Vmtrx.dat')   
      else
         write(*,*) 'ERROR, no Vmtrx input file found'
	 stop
      endif	 

      ex = .false.
      op = .false.
      inquire(file='tdmodel/Vinv.dat',exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(70,file='tdmodel/Vinv.dat')   
      else
         write(*,*) 'ERROR, no Vinv input file found'
	 stop
      endif	 

c-------------------------------------------------------------------------------
c   Reads Te and Ne time dependent data
c-------------------------------------------------------------------------------
      read(40,*) x, Nein(1:nNet*nmtrx)
      do i = 1,nNet
         n = (i-1)*nmtrx + 1
         Net(i) = Nein(n)
      enddo
           
      do n = 1,nTet
         read(40,*) Tet(n), Datain(1:nNet*nmtrx)
	 do i = 1,nNet
	    m = (i-1)*nmtrx
	    do j = 1,nmtrx
	       lamda(n,i,j) = Datain(m+j)
	    enddo
	 enddo
      enddo	 
      close(40)

      read(50,*)
      do n = 1,nTet
         do k = 1,nmtrx 
            read(50,*) x, Datain(1:nNet*nmtrx)
	 
	    do i = 1,nNet
	       m = (i-1)*nmtrx
	       do j = 1,nmtrx
	          Rvect(n,i,k,j) = Datain(m+j)
	       enddo
	    enddo
         enddo
      enddo	 
      close(50)

      read(60,*)
      do n = 1,nTet
         do k = 1,nmtrx 
            read(60,*) x, Datain(1:nNet*nmtrx)
	 
	    do i = 1,nNet
	       m = (i-1)*nmtrx
	       do j = 1,nmtrx
	          VM(n,i,k,j) = Datain(m+j)
	       enddo
	    enddo
         enddo
      enddo	 
      close(60)

      read(70,*)
      do n = 1,nTet
         do k = 1,nmtrx 
            read(70,*) x, Datain(1:nNet*nmtrx)
	 
	    do i = 1,nNet
	       m = (i-1)*nmtrx
	       do j = 1,nmtrx
	          VI(n,i,k,j) = Datain(m+j)
	       enddo
	    enddo
         enddo
      enddo	 
      close(70)

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
c  Sets the initial values of the populations for the time dependent solution
c-------------------------------------------------------------------------------
      No(1:nmtrx) = Noi(1:nmtrx)
      ri = ro
      
      do n = 1,nexp
      
         t = abs(ri-radius(n))/vb	 
         do ntemp = 1,nTet
            do ndens = 1,nNet
c-------------------------------------------------------------------------------
c  Calculates the analytical time dependent solutions
c-------------------------------------------------------------------------------      
               exps(1:nmtrx) = lamda(ntemp,ndens,1:nmtrx)
	       recv(1:nmtrx,1:nmtrx) = 
     &	                            Rvect(ntemp,ndens,1:nmtrx,1:nmtrx) 
	       VRmtr(1:nmtrx,1:nmtrx) = VM(ntemp,ndens,1:nmtrx,1:nmtrx) 
	       VRinv(1:nmtrx,1:nmtrx) = VI(ntemp,ndens,1:nmtrx,1:nmtrx) 
            
               Xv(1:nmtrx) = 0.0_rprec
	       do i = 1,nmtrx
	          do j = 1,nmtrx
	             Xv(i) = Xv(i) + VRinv(i,j)*No(j)
	          enddo
	       enddo

               Yv(:,:) = 0.0_rprec
               do i = 1,nmtrx
	          do j = 1,nmtrx
	             Yv(i,j) = VRmtr(i,j)*Xv(j) + recv(i,j) 
	          enddo
	       enddo
	    
	       Nt(1:nmtrx,ntemp,ndens) = 0.0_rprec
               do i = 1,nmtrx
                  do j = 1,nmtrx
	             Nt(i,ntemp,ndens) = Nt(i,ntemp,ndens) + 
     &		                    Yv(i,j)*dexp(exps(j)*t) - recv(i,j)
                  enddo
               enddo
	    
c-------------------------------------------------------------------------------
c  Computes the line intensities and line ratios
c-------------------------------------------------------------------------------      
               I_667_99 = Nt(10,ntemp,ndens) * Aij_667_99 * 
     &	                  wt_1s_3d_1D2 / totwt_1s_3d_1D 
               I_668_15 = Nt(9,ntemp,ndens) * Aij_668_15 * 
     &	                  wt_1s_3d_3D2 / totwt_1s_3d_3D 
               I_706_71 = Nt(6,ntemp,ndens) * Aij_706_71 * 
     &	                  wt_1s_3s_3S1 / totwt_1s_3s_3S
               I_706_72 = Nt(6,ntemp,ndens) * Aij_706_72 * 
     &	                  wt_1s_3s_3S1 / totwt_1s_3s_3S
               I_706_77 = Nt(6,ntemp,ndens) * Aij_706_77 * 
     &	                  wt_1s_3s_3S1 / totwt_1s_3s_3S
               I_728_34 = Nt(7,ntemp,ndens) * Aij_728_34 * 
     &	                  wt_1s_3s_1S0 / totwt_1s_3s_1S

	       TeRt(ntemp,ndens) = (I_706_71+I_706_72+I_706_77) / 
     &	                           I_728_34
	       NeRt(ntemp,ndens) = (I_667_99+I_668_15)/I_728_34
	       TeNeRt(ntemp,ndens) = (I_706_71+I_706_72+I_706_77) / 
     &	                             (I_667_99+I_668_15)
     	      	       	  
            enddo
         enddo

         min = infinity
	 min_p = infinity
	 min_m = infinity

         do ntemp = 2,nTet-1
	    do ndens = 2,nNet-1
               dTeRtot = dsqrt((dTeRm*TeRt(ntemp,ndens))**2 +
     &	                                       dTeRexp(n)**2) 	       
               dNeRtot = dsqrt((dNeRm*NeRt(ntemp,ndens))**2 +
     &	                                       dNeRexp(n)**2) 	       
               dTeNeRtot = dsqrt((dTeNeRm*TeNeRt(ntemp,ndens))**2 +
     &	                                           dTeNeRexp(n)**2) 	       
	      
               chisqrt = (1.0_rprec-TeRexp(n)/TeRt(ntemp,ndens))**2 +  
     &                   (1.0_rprec-NeRexp(n)/NeRt(ntemp,ndens))**2 +
     &                   (1.0_rprec-TeNeRexp(n)/TeNeRt(ntemp,ndens))**2
               if(chisqrt .lt. min) then
	          min = chisqrt
		  indx_Te = ntemp
		  indx_Ne = ndens
	       endif
	       
               chisq_p = (1.0_rprec-(TeRexp(n)+dTeRtot) / 
     &	                            TeRt(ntemp,ndens))**2 +  
     &                   (1.0_rprec-(NeRexp(n)+dNeRtot) / 
     &                              NeRt(ntemp,ndens))**2 +
     &                   (1.0_rprec-(TeNeRexp(n)+dTeNeRtot) / 
     &                              TeNeRt(ntemp,ndens))**2
               if(chisq_p .lt. min_p) then
	          min_p = chisq_p
		  indx_Tep = ntemp
		  indx_Nep = ndens
	       endif

               chisq_m = (1.0_rprec-(TeRexp(n)-dTeRtot) / 
     &	                            TeRt(ntemp,ndens))**2 +  
     &                   (1.0_rprec-(NeRexp(n)-dNeRtot) / 
     &                              NeRt(ntemp,ndens))**2 +
     &                   (1.0_rprec-(TeNeRexp(n)-dTeNeRtot) / 
     &                              TeNeRt(ntemp,ndens))**2
               if(chisq_m .lt. min_m) then
	          min_m = chisq_m
		  indx_Tem = ntemp
		  indx_Nem = ndens
	       endif
            enddo
	 enddo
	 
	 ri = radius(n)

c-------------------------------------------------------------------------------
c  Interpolates the Te and Ne values using the time dependent model
c-------------------------------------------------------------------------------
         Xvec(1) = Tet(indx_Te+1) - Tet(indx_Te-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*TeRt(indx_Te+1,indx_Ne))- 
     &             dlog10(intpar*TeRt(indx_Te-1,indx_Ne))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Ne+1)) - dlog10(Net(indx_Ne-1))
         Yvec(3) = dlog10(intpar*TeRt(indx_Te,indx_Ne+1))- 
     &             dlog10(intpar*TeRt(indx_Te,indx_Ne-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Tet(indx_Te+1) - Tet(indx_Te-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeRt(indx_Te+1,indx_Ne))- 
     &             dlog10(intpar*NeRt(indx_Te-1,indx_Ne))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Ne+1)) - dlog10(Net(indx_Ne-1))
         Yvec(3) = dlog10(intpar*NeRt(indx_Te,indx_Ne+1))- 
     &             dlog10(intpar*NeRt(indx_Te,indx_Ne-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*TeRexp(n))-  
     &                dlog10(intpar*TeRt(indx_Te,indx_Ne)))
         K2 = Vn2(3)*(dlog10(intpar*NeRexp(n))-  
     &                dlog10(intpar*NeRt(indx_Te,indx_Ne)))


         Tet_exp(n) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	              (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2))+ 
     &                Tet(indx_Te) 

         Net_exp(n) = -(Vn2(1)*(Tet_exp(n)-Tet(indx_Te))+K2)/Vn2(2)+ 
     &                dlog10(Net(indx_Ne))
         Net_exp(n) = (10.0e+0_rprec)**Net_exp(n)		  		  

         Tet_exp(n) = abs(Tet_exp(n))
         Net_exp(n) = abs(Net_exp(n))

         if(Tet_exp(n) .gt. Tet(nTet)) then
            Tet_exp(n) = Tet(nTet)
	    indx_Te = nTet
         endif
         if((Tet_exp(n) .lt. Tet(1)) .or. (isnan(Tet_exp(n)))) then
            Tet_exp(n) = Tet(1)
	    indx_Te = 1
         endif

         if(Net_exp(n) .gt. Net(nNet)) then
            Net_exp(n) = Net(nNet)
	    indx_Ne = nNet
         endif
         if((Net_exp(n) .lt. Net(1)) .or. (isnan(Net_exp(n)))) then
            Net_exp(n) = Net(1)
	    indx_Ne = 1
         endif

         Te_out(n) = Tet_exp(n)
         Ne_out(n) = Net_exp(n)
	 
c-------------------------------------------------------------------------------      
	 No(1:nmtrx) = Nt(1:nmtrx,indx_Te,indx_Ne)
	
c-------------------------------------------------------------------------------
c  Interpolates the Te and Ne uncertainty values using the time dependent model
c-------------------------------------------------------------------------------
         dTeRtot = dsqrt((dTeRm*TeRt(indx_Tep,indx_Nep))**2 +
     &	                                        dTeRexp(n)**2) 	       
         dNeRtot = dsqrt((dNeRm*NeRt(indx_Tep,indx_Nep))**2 +
     &	                                        dNeRexp(n)**2) 	       
         dTeNeRtot = dsqrt((dTeNeRm*TeNeRt(indx_Tep,indx_Nep))**2 +
     &	                                            dTeNeRexp(n)**2) 	       

         Xvec(1) = Tet(indx_Tep+1) - Tet(indx_Tep-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*TeRt(indx_Tep+1,indx_Nep)) - 
     &             dlog10(intpar*TeRt(indx_Tep-1,indx_Nep))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Nep+1)) - dlog10(Net(indx_Nep-1))
         Yvec(3) = dlog10(intpar*TeRt(indx_Tep,indx_Nep+1)) - 
     &             dlog10(intpar*TeRt(indx_Tep,indx_Nep-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Tet(indx_Tep+1) - Tet(indx_Tep-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeRt(indx_Tep+1,indx_Nep)) - 
     &             dlog10(intpar*NeRt(indx_Tep-1,indx_Nep))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Nep+1)) - dlog10(Net(indx_Nep-1))
         Yvec(3) = dlog10(intpar*NeRt(indx_Tep,indx_Nep+1)) - 
     &             dlog10(intpar*NeRt(indx_Tep,indx_Nep-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*(TeRexp(n)+dTeRtot)) -  
     &                dlog10(intpar*TeRt(indx_Tep,indx_Nep)))
         K2 = Vn2(3)*(dlog10(intpar*(NeRexp(n)+dNeRtot)) -  
     &                dlog10(intpar*NeRt(indx_Tep,indx_Nep)))


         dTet_exp(n,2) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	                 (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2)) + 
     &                   Tet(indx_Tep) 

         dNet_exp(n,1) = -(Vn2(1)*(dTet_exp(n,2) - 
     &	                   Tet(indx_Tep))+K2)/Vn2(2) + 
     &                   dlog10(Net(indx_Nep))
         dNet_exp(n,1) = (10.0e+0_rprec)**dNet_exp(n,1)		  		  

         dTet_exp(n,2) = abs(dTet_exp(n,2))
         dNet_exp(n,1) = abs(dNet_exp(n,1))

         if(dTet_exp(n,2) .gt. Tet(nTet)) then
            dTet_exp(n,2) = Tet(nTet)
         endif
         if(dTet_exp(n,2) .lt. Tet(1)) then
            dTet_exp(n,2) = Tet(1)
         endif

         if(dNet_exp(n,1) .gt. Net(nNet)) then
            dNet_exp(n,1) = Net(nNet)
         endif
         if(dNet_exp(n,1) .lt. Net(1)) then
            dNet_exp(n,1) = Net(1)
         endif

         dTet_exp(n,2) = abs(Tet_exp(n)-dTet_exp(n,2))
         dNet_exp(n,1) = abs(Net_exp(n)-dNet_exp(n,1))

	 if(isnan(dTet_exp(n,2))) then
	    dTet_exp(n,2) = 0.0_rprec
	 endif    
	 if(isnan(dNet_exp(n,1))) then
	    dNet_exp(n,1) = 0.0_rprec
	 endif    

         dTe_out(n,2) = dTet_exp(n,2)
         dNe_out(n,1) = dNet_exp(n,1)

c-------------------------------------------------------------------------------
         dTeRtot = dsqrt((dTeRm*TeRt(indx_Tem,indx_Nem))**2 +
     &	                                        dTeRexp(n)**2) 	       
         dNeRtot = dsqrt((dNeRm*NeRt(indx_Tem,indx_Nem))**2 +
     &	                                        dNeRexp(n)**2) 	       
         dTeNeRtot = dsqrt((dTeNeRm*TeNeRt(indx_Tem,indx_Nem))**2 +
     &	                                            dTeNeRexp(n)**2) 	       

         Xvec(1) = Tet(indx_Tem+1) - Tet(indx_Tem-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*TeRt(indx_Tem+1,indx_Nem))- 
     &             dlog10(intpar*TeRt(indx_Tem-1,indx_Nem))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Nem+1)) - dlog10(Net(indx_Nem-1))
         Yvec(3) = dlog10(intpar*TeRt(indx_Tem,indx_Nem+1))- 
     &             dlog10(intpar*TeRt(indx_Tem,indx_Nem-1))

         Vn1(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn1(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn1(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn1(1)**2 + Vn1(2)**2 + Vn1(3)**2)
         Vn1(1:3) = Vn1(1:3)/Vmag 

         Xvec(1) = Tet(indx_Tem+1) - Tet(indx_Tem-1)
         Xvec(2) = 0.0_rprec
         Xvec(3) = dlog10(intpar*NeRt(indx_Tem+1,indx_Nem)) - 
     &             dlog10(intpar*NeRt(indx_Tem-1,indx_Nem))

         Yvec(1) = 0.0_rprec
         Yvec(2) = dlog10(Net(indx_Nem+1)) - dlog10(Net(indx_Nem-1))
         Yvec(3) = dlog10(intpar*NeRt(indx_Tem,indx_Nem+1)) - 
     &             dlog10(intpar*NeRt(indx_Tem,indx_Nem-1))

         Vn2(1) = Xvec(2)*Yvec(3) - Xvec(3)*Yvec(2)
         Vn2(2) = Xvec(3)*Yvec(1) - Xvec(1)*Yvec(3)
         Vn2(3) = Xvec(1)*Yvec(2) - Xvec(2)*Yvec(1)

         Vmag = dsqrt(Vn2(1)**2 + Vn2(2)**2 + Vn2(3)**2)
         Vn2(1:3) = Vn2(1:3)/Vmag 

         K1 = Vn1(3)*(dlog10(intpar*(TeRexp(n)-dTeRtot)) -  
     &                dlog10(intpar*TeRt(indx_Tem,indx_Nem)))
         K2 = Vn2(3)*(dlog10(intpar*(NeRexp(n)-dNeRtot)) -  
     &                dlog10(intpar*NeRt(indx_Tem,indx_Nem)))

         dTet_exp(n,1) = (Vn1(2)*K2/Vn2(2)-K1)/
     &	                 (Vn1(1)-Vn1(2)*Vn2(1)/Vn2(2)) + 
     &                   Tet(indx_Tem) 

         dNet_exp(n,2) = -(Vn2(1)*(dTet_exp(n,1) - 
     &	                 Tet(indx_Tem))+K2)/Vn2(2) + 
     &                   dlog10(Net(indx_Nem))
         dNet_exp(n,2) = (10.0e+0_rprec)**dNet_exp(n,2)		  		  

         dTet_exp(n,1) = abs(dTet_exp(n,1))
         dNet_exp(n,2) = abs(dNet_exp(n,2))

         if(dTet_exp(n,1) .gt. Tet(nTet)) then
            dTet_exp(n,1) = Tet(nTet)
         endif
         if(dTet_exp(n,1) .lt. Tet(1)) then
            dTet_exp(n,1) = Tet(1)
         endif

         if(dNet_exp(n,2) .gt. Net(nNet)) then
            dNet_exp(n,2) = Net(nNet)
         endif
         if(dNet_exp(n,2) .lt. Net(1)) then
            dNet_exp(n,2) = Net(1)
         endif

         dTet_exp(n,1) = abs(Tet_exp(n)-dTet_exp(n,1))
         dNet_exp(n,2) = abs(Net_exp(n)-dNet_exp(n,2))
	 
	 if(isnan(dTet_exp(n,1))) then
	    dTet_exp(n,1) = 0.0_rprec
	 endif    
	 if(isnan(dNet_exp(n,2))) then
	    dNet_exp(n,2) = 0.0_rprec
	 endif    

         dTe_out(n,1) = dTet_exp(n,1)
         dNe_out(n,2) = dNet_exp(n,2)

      enddo
      
c-------------------------------------------------------------------------------
c  End of subroutine
c-------------------------------------------------------------------------------
      end subroutine tdmodel

c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------




