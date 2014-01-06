#pragma rtGlobals=1		// Use modern global access method.

Function GetTimes()
	
	Wave y_she_corr
	Wave x_she1
	
	Make/n=1/o tValues,temp
	Wavestats/Q x_she1
	Variable i, hold
	for(i=0;i<V_npnts;i+=1)
		hold=y_she_corr[i]
		if(hold>0.5)
			temp = x_she1[i]
			Concatenate/NP {temp},tValues
		endif
	endfor
	DeletePoints 0,1,tValues
	KillWaves/Z temp
End

Function FindIndex()
	
	DFREF dREF = root:s118794_wavs
	Wave/SDFR=dREF tValues
	
	Make/n=1 holder
	
	WaveStats/Q tValues
	Variable i,hold
	for(i=0;i<V_npnts;i+=1)
		hold = tValue[i]
		FindValue/V=hold/T=1e-2 tBase_L
	endfor
End