#pragma rtGlobals=1		// Use modern global access method.

Function MakeRatio(CHDwav, setupNum, shot)
	Wave CHDwav
	Variable setupNum
	Variable shot	
	SetDataFolder root:
	
	Wave/T RefNamwav
	
	String folder = "HELIOSFS_"+num2istr(shot)
	SetDataFolder folder
	Wave Samples
	Wave tBase
	SetDataFolder root:
	
	DFREF RtDF=root:
	Variable/G npnts
	Variable/G tottime
	NVAR/SDFR=RtDF baseNum
	npnts = Samples[0]/baseNum
	Wavestats/Q tBase
	tottime = abs(tBase(V_endRow))+abs(tBase(V_startRow))
	
	variable i,j
	for(i=0;i<12;i+=1)
		String hold = "CH"+num2istr(CHDwav[i][setupNum])+"_R728706" 
		String hold2 = "CH"+num2istr(CHDwav[i][setupNum])+"_R668728"
		Make/N=(npnts)/O/S $hold,$hold2
		
		Wave wav1 = $hold
		Wave wav2 = $hold2
		 
		for(j=(4*i);j<(4*i+4); j+=1)
			if(j<12 && j==0 || j==4 || j==8)
				String hold3 = RefNamwav[j]+"_L_fin"
				String hold4 = RefNamwav[j+1]+"_L_fin"
				String hold5 = RefNamwav[j+2]+"_L_fin"
				Wave wav3 = $hold3
				wav3 -=mean(wav3,10,10)
				Wave wav4 = $hold4
				wav4 -=mean(wav4,10,10)
				Wave wav5 = $hold5
				wav5-=mean(wav5,10,10)
				wav1[] =  wav3[p]/wav4[p]
				wav2[] = wav5[p]/wav3[p] 
			endif
			if(j>11 && j<24 && j==15 || j==19 || j==23)
				hold3 = RefNamwav[j]+"_L_fin"
				hold4 = RefNamwav[j-1]+"_L_fin"
				hold5 = RefNamwav[j-2]+"_L_fin"
				Wave wav3 = $hold3
				wav3 -=mean(wav3,10,10)
				Wave wav4 = $hold4
				wav4 -=mean(wav4,10,10)
				Wave wav5 = $hold5
				wav5-=mean(wav5,10,10)
				wav1[] =  wav3[p]/wav4[p]
				wav2[] = wav5[p]/wav3[p] 
			endif
			if(j>23 && j<36 && j==24 || j==28 || j==32)
				hold3 = RefNamwav[j]+"_L_fin"
				hold4 = RefNamwav[j+1]+"_L_fin"
				hold5 = RefNamwav[j+2]+"_L_fin"
				Wave wav3 = $hold3
				wav3 -=mean(wav3,10,10)
				Wave wav4 = $hold4
				wav4 -=mean(wav4,10,10)
				Wave wav5 = $hold5
				wav5-=mean(wav5,10,10)
				wav1[] =  wav3[p]/wav4[p]
				wav2[] = wav5[p]/wav3[p] 
			endif
			if(j>35 && j<48 && j== 39 || j==43 || j==47)
				hold3 = RefNamwav[j]+"_L_fin"
				hold4 = RefNamwav[j-1]+"_L_fin"
				hold5 = RefNamwav[j-2]+"_L_fin"
				Wave wav3 = $hold3
				wav3 -=mean(wav3,10,10)
				print hold3, mean(wav3,4,10)
				Wave wav4 = $hold4
				wav4 -=mean(wav4,10,10)
				print hold4, mean(wav4,4,10)
				Wave wav5 = $hold5
				wav5-=mean(wav5,10,10)
				print hold5, mean(wav5,4,10)
				wav1[] =  wav3[p]/wav4[p]
				wav2[] = wav5[p]/wav3[p] 
			endif
		endfor
	endfor

End