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
	
	DFREF dREF = root:s118797_wavs
	Wave/SDFR=dREF tValues
	
	Wave tBase_L_fix
	
	Make/n=1/o holder,tIndex,temp,temp2
	
	WaveStats/Q tValues
	Variable i,hold
	for(i=0;i<V_npnts;i+=1)
		hold = tValues[i]
		FindValue/V=(hold)/T=1e-2 tBase_L_fix
		holder = V_value
		Concatenate/NP {holder},temp
	endfor
	DeletePoints 0,1,tIndex
	
	WaveStats/Q temp
	Variable t1,t2
	for(i=1;i<V_npnts;i+=1)
		if(temp[i]!=temp[i-1])
			temp2=temp[i]
			Concatenate/NP {temp2},tIndex
		endif
	endfor
		KillWaves/Z holder,temp,temp2
End

Function TruncWavs()

	Wave tIndex
	Wave tBase_L
	Wave CH214_R668728,CH214_R728706,CH215_R668728,CH215_R728706,CH216_R668728
	Wave CH216_R728706,CH217_R668728,CH217_R728706,CH218_R668728,CH218_R728706
	Wave CH219_R668728,CH219_R728706,CH220_R668728,CH220_R728706,CH221_R668728
	Wave CH221_R728706,CH222_R668728,CH222_R728706,CH223_R668728,CH223_R728706
	Wave CH224_R668728,CH224_R728706,CH225_R668728,CH225_R728706
	
	Duplicate/O tIndex, tBase_TRUNC,CH214_R668728_TRUNC,CH214_R728706_TRUNC
	Duplicate/O tIndex, CH215_R668728_TRUNC,CH215_R728706_TRUNC,CH216_R668728_TRUNC
	Duplicate/O tIndex,CH216_R728706_TRUNC,CH217_R668728_TRUNC,CH217_R728706_TRUNC
	Duplicate/O tIndex,CH218_R668728_TRUNC,CH218_R728706_TRUNC
	Duplicate/O tIndex,CH219_R668728_TRUNC,CH219_R728706_TRUNC,CH220_R668728_TRUNC
	Duplicate/O tIndex,CH220_R728706_TRUNC,CH221_R668728_TRUNC
	Duplicate/O tIndex,CH221_R728706_TRUNC,CH222_R668728_TRUNC,CH222_R728706_TRUNC
	Duplicate/O tIndex,CH223_R668728_TRUNC,CH223_R728706_TRUNC
	Duplicate/O tIndex,CH224_R668728_TRUNC,CH224_R728706_TRUNC,CH225_R668728_TRUNC
	Duplicate/O tIndex,CH225_R728706_TRUNC
	
	tBase_TRUNC = tBase_L[tIndex]
	CH214_R668728_TRUNC=CH214_R668728[tIndex]
	CH214_R728706_TRUNC=CH214_R728706[tIndex]
	CH215_R668728_TRUNC=CH215_R668728[tIndex]
	CH215_R728706_TRUNC=CH215_R728706[tIndex]
	CH216_R668728_TRUNC=CH216_R668728[tIndex]
	CH216_R728706_TRUNC=CH216_R728706[tIndex]
	CH217_R668728_TRUNC=CH217_R668728[tIndex]
	CH217_R728706_TRUNC=CH217_R728706[tIndex]
	CH218_R668728_TRUNC=CH218_R668728[tIndex]
	CH218_R728706_TRUNC=CH218_R728706[tIndex]
	CH219_R668728_TRUNC=CH219_R668728[tIndex]
	CH219_R728706_TRUNC=CH219_R728706[tIndex]
	CH220_R668728_TRUNC=CH220_R668728[tIndex]
	CH220_R728706_TRUNC=CH220_R728706[tIndex]
	CH221_R668728_TRUNC=CH221_R668728[tIndex]
	CH221_R728706_TRUNC=CH221_R728706[tIndex]
	CH222_R668728_TRUNC=CH222_R668728[tIndex]
	CH222_R728706_TRUNC=CH222_R728706[tIndex]
	CH223_R668728_TRUNC=CH223_R668728[tIndex]
	CH223_R728706_TRUNC=CH223_R728706[tIndex]
	CH224_R668728_TRUNC=CH224_R668728[tIndex]
	CH224_R728706_TRUNC=CH224_R728706[tIndex]
	CH225_R668728_TRUNC=CH225_R668728[tIndex]
	CH225_R728706_TRUNC=CH225_R728706[tIndex]
End

Function TEX_CRM(shot,nemin,nemax,temin,temax,rne_2d,rte_2d)
	variable shot
	variable nemin
	variable nemax
	variable temin
	variable temax
	wave rne_2d
	wave rte_2d
	
	tic()
	Duplicate/o rne_2d ne_TEXTOR2d
	Duplicate/o rte_2d te_TeXTOR2d
	
	Variable pntCmd = 0
	Variable pntRlt = 0
	
	Variable rne
	Variable rte
	string CRMoutStr
	Make/O/N=2 neTeWav
	
	Variable k,l,m
	Variable endrow = dimsize(rne_2d,0)
	Variable endcol  = dimsize(rne_2d,1)
	
	m=0
	for(k=0;k<endrow;k +=1)
		for(l=0;l<endcol;l +=1)
			rne = rne_2d[k][l]
			rte = rte_2d[k][l]
			CRMoutStr= ExecutePythonShellCommand2(pntCmd, pntRlt,shot,nemin,nemax,temin,temax,rne,rte)
			neTeWav = parseFUNC(CRMoutStr)
			ne_TEXTOR2d[k][l] = neTeWav[0]
			te_TEXTOR2d[k][l] = neTeWav[1]
		
		endfor
		m +=1
		printf "Time: %0.1f\r",(m/176)*100
	endfor
	toc()
End

Function/S ExecutePythonShellCommand2(printCommandInHistory, printResultInHistory,shot,nemin,nemax,temin,temax,rne,rte)
	Variable printCommandInHistory
	Variable printResultInHistory
	Variable shot
	Variable nemin
	Variable nemax
	Variable temin
	Variable temax
	Variable rne
	Variable rte

	String uCommand =". ${HOME}/.bash_profile; python Users/unterbee/helios/CRM_sources/TEXTOR/textorCRM.py" 
	uCommand = uCommand+" "+num2istr(shot)+" "+num2str(temin)+" "+num2str(temax)+" "+num2str(nemin)+" "+num2str(nemax)+" "+num2str(rne)+" "+num2str(rte)
	
	if (printCommandInHistory)
		printf "Unix command: %s\r", uCommand
	endif
	
	String cmd
	sprintf cmd, "do shell script \"%s\"", uCommand
	ExecuteScriptText cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End

Function  parseFUNC(inSTR)
	string inSTR
	
	String out1,out2,out3,out4,out5
	make/n=2 numsout
	variable v1,v2
	sscanf inSTR, "%s %s %s %s %s %f %f",out1,out2,out3,out4,out5,v1,v2
	
	numsout[0] = v1
	numsout[1] = v2
	return numsout
End