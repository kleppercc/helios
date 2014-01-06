c-------------------------------------------------------------------------------
c
c     Helios Line Ratio Diagnostic Program   
c
c     Authors : Jorge M. Munoz Burgos 
c     General Atomics / Auburn University    
c
c     Date : March 2013
c
c-------------------------------------------------------------------------------
      program helios
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
c  Ion beam parameters
c-------------------------------------------------------------------------------
      real(rprec), parameter :: vb = 1.5e+3_rprec
      real(rprec), parameter :: ro = 0.554_rprec
      real(rprec), parameter :: Ne_ref = 1.0e+12_rprec

c-------------------------------------------------------------------------------
c  Smoothing parameters
c-------------------------------------------------------------------------------
      integer(iprec), parameter :: np = 101_iprec
      integer(iprec), parameter :: ld = 0_iprec
      integer(iprec), parameter :: mp = 5_iprec
      logical, parameter :: smth = .false.
                            
c-------------------------------------------------------------------------------
c  Variables declaration
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c-- processing variables ------------------------------------------------------- 
c-------------------------------------------------------------------------------
      character(len=200) :: data_file      
      logical :: ex, op
      integer(iprec) :: i, j, k, n
      integer(iprec) :: nexp, ndt
      real(rprec) :: chi_te_ne, chi_te_ne_o
        
c-------------------------------------------------------------------------------
c-- allocatable variables ------------------------------------------------------ 
c-------------------------------------------------------------------------------
      real(rprec), allocatable :: I_667exp(:), I_706exp(:), I_728exp(:)
      real(rprec), allocatable :: I_667(:), I_706(:), I_728(:)
      real(rprec), allocatable :: dI_667exp(:), dI_706exp(:)
      real(rprec), allocatable :: dI_728exp(:), radius(:)
      real(rprec), allocatable :: Te_exp(:), Ne_exp(:)
      real(rprec), allocatable :: dTe_exp(:,:), dNe_exp(:,:)
      real(rprec), allocatable :: Tet_exp(:), Net_exp(:)
      real(rprec), allocatable :: dTet_exp(:,:), dNet_exp(:,:)
      
c-------------------------------------------------------------------------------
c-- smoothing variables -------------------------------------------------------- 
c-------------------------------------------------------------------------------
      real(rprec) :: c(np), gi
      integer(iprec) :: nl, nr
      integer(iprec) :: flagx

c-------------------------------------------------------------------------------
c  Data formats
c-------------------------------------------------------------------------------	    
100   format(1x,a9,3x,a6,6x,a6,9x,a4,7x,a9,6x,a4,9x,a4)
110   format(1x,f8.6,1x,es12.6,1x,es12.6,1x,es12.6,1x,
     &                      es12.6,1x,es12.6,1x,es12.6)
120   format(1x,i3,2x,f9.4,2x,es12.5)

c-------------------------------------------------------------------------------
c  Data initialization
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c  Executes the program
c-------------------------------------------------------------------------------
      write(*,*)
      write(*,*) '  Start of program'
      write(*,*)
      
c-------------------------------------------------------------------------------
c  Reads experimental data and calculates experimental line ratios
c-------------------------------------------------------------------------------
      data_file = 'expdata/101401/HeInts.txt'
c      data_file = 'expdata/102175/HeInts.txt'
c      data_file = 'expdata/102118/HeInts.txt'
c      data_file = 'expdata/101738/HeInts.txt'
c      data_file = 'expdata/101818/HeInts.txt'
c      data_file = 'expdata/101795/HeInts.txt'

      ex = .false.
      op = .false.
      inquire(file=data_file,exist=ex,opened=op)
      if((ex .eqv. .true.).and.(op .eqv. .false.)) then
         open(80,file=data_file)   
      else
         write(*,*) 'ERROR, no ', data_file, 'input file found'
	 stop
      endif
      
      read(80,*)
      read(80,*) nexp
      
      allocate(I_667exp(nexp),I_706exp(nexp),I_728exp(nexp))
      allocate(I_667(nexp),I_706(nexp),I_728(nexp))
      allocate(dI_667exp(nexp),dI_706exp(nexp),dI_728exp(nexp))
      allocate(radius(nexp))
      allocate(Te_exp(nexp),Ne_exp(nexp))
      allocate(dTe_exp(nexp,2),dNe_exp(nexp,2))
      allocate(Tet_exp(nexp),Net_exp(nexp))
      allocate(dTet_exp(nexp,2),dNet_exp(nexp,2))
      
      do n = 1,nexp
         read(80,*) radius(n), I_667exp(n), I_706exp(n), I_728exp(n),  
     &              dI_667exp(n), dI_706exp(n), dI_728exp(n)
         radius(n) = abs(radius(n))
	 I_667(n) = abs(I_667exp(n))
	 I_706(n) = abs(I_706exp(n))
	 I_728(n) = abs(I_728exp(n))
	 dI_667exp(n) = abs(dI_667exp(n))
	 dI_706exp(n) = abs(dI_706exp(n))
	 dI_728exp(n) = abs(dI_728exp(n))
      enddo
      
      close(80)

c-------------------------------------------------------------------------------
c  Smooths the experimental data by using Savitzky-Golay coefficients
c-------------------------------------------------------------------------------
      if(smth .eqv. .true.) then
         flagx = 0
         do n = 1,nexp      
            if(n .le. np/2_iprec) then
	       nl = n-1
	       if(nl .lt. 0) then
	          nl = 0
	       endif
	       nr = np-nl-1
	       call savgol(c,np,nl,nr,ld,mp)
	    elseif((nexp-n) .le. np/2_iprec) then
	       nr = np/2_iprec-(nexp-n)
	       nl = np-nr-1
	       call savgol(c,np,nl,nr,ld,mp)
	    else
	       nr = np/2_iprec
	       nl = np/2_iprec
	       if(flagx .eq. 0) then
	          call savgol(c,np,nl,nr,ld,mp)
	          flagx = 1	    
	       endif
	    endif
	  
	    gi = 0.0_rprec
	    do i = 1,nl+1
	       j = n-i+1
	       gi = gi + c(i)*I_667exp(j)
	    enddo
	    k = 0
	    do i = nl+2,np
	       j = n+nr-k
	       gi = gi + c(i)*I_667exp(j)
	       k = k + 1
	    enddo
	    I_667(n) = gi       
      
	    gi = 0.0_rprec
	    do i = 1,nl+1
	       j = n-i+1
	       gi = gi + c(i)*I_706exp(j)
	    enddo
	    k = 0
	    do i = nl+2,np
	       j = n+nr-k
	       gi = gi + c(i)*I_706exp(j)
	       k = k + 1
	    enddo
	    I_706(n) = gi       

	    gi = 0.0_rprec
	    do i = 1,nl+1
	       j = n-i+1
	       gi = gi + c(i)*I_728exp(j)
	    enddo
	    k = 0
	    do i = nl+2,np
	       j = n+nr-k
	       gi = gi + c(i)*I_728exp(j)
	       k = k + 1
	    enddo
	    I_728(n) = gi       
      
         enddo
      endif
      
c-------------------------------------------------------------------------------
c  Calculates the experimental Te and Ne values using the equilibrium model
c-------------------------------------------------------------------------------
      write(*,*) 'Calculating Te and Ne with the Equilibrium Model'
      call eqmodel(nexp,I_667,I_706,I_728,dI_667exp,dI_706exp,dI_728exp, 
     &                                    Te_exp,Ne_exp,dTe_exp,dNe_exp)

      do n = 1,nexp
	 write(*,120) n, Te_exp(n), Ne_exp(n)
      enddo
      write(*,*)
      	 
c-------------------------------------------------------------------------------
c  Calculates the analytical time dependent solutions
c-------------------------------------------------------------------------------      
      write(*,*) 'Calculating Te and Ne with the Time-Dependent Model'
      call tdmodel_fast(nexp,vb,ro,radius,
     &             I_667,I_706,I_728,dI_667exp,dI_706exp,dI_728exp, 
     &                            Tet_exp,Net_exp,dTet_exp,dNet_exp)

      do n = 1,nexp
	 write(*,120) n, Tet_exp(n), Net_exp(n)
      enddo
      write(*,*)

c-------------------------------------------------------------------------------      
c This is to descriminate points from the TD model that are at higher densities 
c-------------------------------------------------------------------------------      
      chi_te_ne_o = infinity
      do n = 1,nexp
         chi_te_ne = (1.0_rprec - Tet_exp(n)/Te_exp(n))**2 + 
     &               (1.0_rprec - Net_exp(n)/Ne_exp(n))**2

         if((Net_exp(n) .ge. Ne_ref) .and. (n .gt. 11)) then
	    if(chi_te_ne .le. chi_te_ne_o) then
	       chi_te_ne_o = chi_te_ne
	    else
	       ndt = n - 1
	       exit
	    endif   
	 endif

      enddo

      do n = 1,ndt
         Te_exp(n) = Tet_exp(n)
         dTe_exp(n,1:2) = dTet_exp(n,1:2)

         if(Net_exp(n) .lt. Ne_exp(n)) then 
	    Ne_exp(n) = Net_exp(n)
	    dNe_exp(n,1:2) = dNet_exp(n,1:2)
	 endif	 
      enddo

c-------------------------------------------------------------------------------      
c   Writes to the output files
c-------------------------------------------------------------------------------      
      open(90,file='TeNe.dat')
      write(90,100) 'Radius(m)', 'Te(eV)', '+dTe', '-dTe', 
     &                           'Ne(cm^-3)', '+dNe', '-dNe'
      do n = 1,nexp
         write(90,110) radius(n),  
     &	               Te_exp(n), dTe_exp(n,1), dTe_exp(n,2),
     &	               Ne_exp(n), dNe_exp(n,1), dNe_exp(n,2)
      enddo
      close(90)  

      call system('gnuplot < gnu_script_te')
      call system('gnuplot < gnu_script_ne')
      call system('kghostview Te_Plot.eps &')
      call system('kghostview Ne_Plot.eps &')
	
c-------------------------------------------------------------------------------      
c   Deallocates arrays
c-------------------------------------------------------------------------------      
      deallocate(I_667exp,I_706exp,I_728exp)
      deallocate(I_667,I_706,I_728)
      deallocate(dI_667exp,dI_706exp,dI_728exp)
      deallocate(radius)
      deallocate(Te_exp,Ne_exp)
      deallocate(dTe_exp,dNe_exp)
      deallocate(Tet_exp,Net_exp)
      deallocate(dTet_exp,dNet_exp)
      
c-------------------------------------------------------------------------------
c  End of program
c-------------------------------------------------------------------------------
      write(*,*) 'End of program'
	     	     
      end program helios

c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------

c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
      subroutine savgol(c,np,nl,nr,ld,m)

c-------------------------------------------------------------------------------
c  Type declarations - lengths of reals, integers, and complexes
c-------------------------------------------------------------------------------
      integer, parameter :: rprec = SELECTED_REAL_KIND(12,100)
      integer, parameter :: iprec = SELECTED_INT_KIND(12)
      integer, parameter :: rdprec = SELECTED_REAL_KIND(6,37)
      integer, parameter :: cprec = KIND((1.0_rprec,1.0_rprec))

c-------------------------------------------------------------------------------
      integer(iprec) ld,m,nl,np,nr,MMAX
      real(rprec) c(np)
      parameter (MMAX=6)
      integer(iprec) imj,ipj,j,k,kk,mm,indx(MMAX+1)
      real(rprec) d,fac,sum,a(MMAX+1,MMAX+1),b(MMAX+1)
      
      if(np.lt.nl+nr+1.or.nl.lt.0.or.nr.lt.0.or.ld.gt.m.or.m.gt.MMAX
     &     .or.nl+nr.lt.m) pause 'bad args in savgol'
      do ipj=0,2*m
         sum=0.0_rprec
	 if(ipj.eq.0)sum=1.0_rprec
	 do k=1,nr
	    sum=sum+float(k)**ipj
	 enddo
	 do k=1,nl
	    sum=sum+float(-k)**ipj
	 enddo
	 mm=min(ipj,2*m-ipj)
	 do imj=-mm,mm,2
	    a(1+(ipj+imj)/2,1+(ipj-imj)/2)=sum
	 enddo
      enddo
      call ludcmp(a,m+1,MMAX+1,indx,d)
      do j=1,m+1
         b(j)=0.0_rprec
      enddo
      b(ld+1)=1.
      call lubksb(a,m+1,MMAX+1,indx,b)
      do kk=1,np
         c(kk)=0.0_rprec
      enddo
      do k=-nl,nr
         sum=b(1)
	 fac=1.0_rprec
	 do mm=1,m
	    fac=fac*k
	    sum=sum+b(mm+1)*fac
	 enddo
	 kk=mod(np-k,np)+1
	 c(kk)=sum
      enddo
      return
      end
      
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
      subroutine ludcmp(a,n,np,indx,d)

c-------------------------------------------------------------------------------
c  Type declarations - lengths of reals, integers, and complexes
c-------------------------------------------------------------------------------
      integer, parameter :: rprec = SELECTED_REAL_KIND(12,100)
      integer, parameter :: iprec = SELECTED_INT_KIND(12)
      integer, parameter :: rdprec = SELECTED_REAL_KIND(6,37)
      integer, parameter :: cprec = KIND((1.0_rprec,1.0_rprec))

c-------------------------------------------------------------------------------
      integer(iprec) n,np,indx(n),NMAX
      real(rprec) d,a(np,np),TINY
      parameter (NMAX=500,TINY=1.0e-20)
      integer(iprec) i,imax,j,k
      real(rprec) aamax,dum,sum,vv(NMAX)
      
      d=1.0_rprec
      do i=1,n
         aamax=0.0_rprec
	 do j=1,n
	    if(abs(a(i,j)).gt.aamax) aamax=abs(a(i,j))
	 enddo
	 if(aamax.eq.0.0_rprec) pause 'singular matrix in ludcmp'
	 vv(i)=1./aamax
      enddo
      do j=1,n
         do i=1,j-1
	    sum=a(i,j)
	    do k=1,i-1
	       sum=sum-a(i,k)*a(k,j)
	    enddo
	    a(i,j)=sum
	 enddo
	 aamax=0.0_rprec
	 do i=j,n
	    sum=a(i,j)
	    do k=1,j-1
	       sum=sum-a(i,k)*a(k,j)
	    enddo
	    a(i,j)=sum
	    dum=vv(i)*abs(sum)
	    if(dum.ge.aamax) then
	       imax=i
	       aamax=dum
	    endif
	 enddo
	 if(j.ne.imax) then
	    do k=1,n
	       dum=a(imax,k)
	       a(imax,k)=a(j,k)
	       a(j,k)=dum
	    enddo
	    d=-d
	    vv(imax)=vv(j)
	 endif
	 indx(j)=imax
	 if(a(j,j).eq.0.0_rprec) a(j,j)=TINY
	 if(j.ne.n) then
	    dum=1./a(j,j)
	    do i=j+1,n
	       a(i,j)=a(i,j)*dum
	    enddo
	 endif
      enddo
      return
      end
      
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------
      subroutine lubksb(a,n,np,indx,b)

c-------------------------------------------------------------------------------
c  Type declarations - lengths of reals, integers, and complexes
c-------------------------------------------------------------------------------
      integer, parameter :: rprec = SELECTED_REAL_KIND(12,100)
      integer, parameter :: iprec = SELECTED_INT_KIND(12)
      integer, parameter :: rdprec = SELECTED_REAL_KIND(6,37)
      integer, parameter :: cprec = KIND((1.0_rprec,1.0_rprec))

c-------------------------------------------------------------------------------
      integer(iprec) n,np,indx(n)
      real(rprec) a(np,np),b(n)
      integer(iprec) i,ii,j,ll
      real(rprec) sum
      ii=0
      do i=1,n
         ll=indx(i)
	 sum=b(ll)
	 b(ll)=b(i)
	 if(ii.ne.0) then
	    do j=ii,i-1
	       sum=sum-a(i,j)*b(j)
	    enddo
	 elseif(sum.ne.0.0_rprec) then
	    ii=i
	 endif
	 b(i)=sum
      enddo
      do i=n,1,-1
         sum=b(i)
	 do j=i+1,n
	    sum=sum-a(i,j)*b(j)
	 enddo
	 b(i)=sum/a(i,i)
      enddo
      return
      end

c-------------------------------------------------------------------------------
c-------------------------------------------------------------------------------



