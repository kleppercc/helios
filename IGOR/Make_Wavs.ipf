#pragma rtGlobals=1		// Use modern global access method.

Function Make_wavs(NumTubes,baseNum,pntsm,interppnt,shot,frac)
	Variable NumTubes
	Variable baseNum  //= 1000
	Variable pntsm
	Variable interppnt
	Variable shot	
	Variable frac //=0.01
	//NumTubes =48
	
	SetDataFolder root:
	String folder = "HELIOSFS_"+num2istr(shot)
	SetDataFolder folder
	Wave/T PMTDESC_array
	Wave Samples
	Wave FILTFLUX_array
	Wave tBase
	
	SetDataFolder root:
	
	DFREF RtDF=::
	Variable/G npnts
	Variable/G tottime
	npnts = Samples[0]
	
	Wavestats/Q tBase
	tottime = abs(tBase(V_endRow))+abs(tBase(V_startRow))
	
	Make/N=(NumTubes)/O/T RefNamwav
	Variable i
	for(i=0;i<NumTubes;i+=1)
		String hold = PMTDESC_array[i]
		String hold2="tb"+hold[2,9]
		Make/N=(Samples[0])/O/S $hold2
		RefNamwav[i] = hold2
		Wave wav1 = $hold2
		wav1[] = FILTFLUX_array[p][i]
		if (i==0)
			Interpolate2/I=3/T=1/N=(Samples[0]/basenum)/A=(Samples[0]/basenum)/J=0/Y=$hold2+"_L"/X=tBase_L tBase, wav1
			Redimension/S tBase_L			
		else
			Interpolate2/T=1/N=(Samples[0]/basenum)/A=(Samples[0]/basenum)/J=0/Y=$hold2+"_L"/X=tBase_L tBase,wav1
		endif
		Redimension/S $hold2+"_L"
		Takeoff_bac(pntsm,interppnt,hold2+"_L",tbase_l,frac)
	endfor 
	SetDataFolder root:
End