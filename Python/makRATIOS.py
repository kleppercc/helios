import numpy as np
import pandas as pds

def run(shot,HeliosDFram,CHDwav,CHDsetupNum):
	
	prefix = 'CHD'
	suffix1 = '_R728706'
	suffix2 = '_R668728'
	# String hold = "CH"+num2istr(CHDwav[i][setupNum])+"_R728706"
	# String hold2 = "CH"+num2istr(CHDwav[i][setupNum])+"_R668728"
	# hold3 == 728
	# hold4 == 706
	# hold5 == 668

	for i in xrange(12):
		for j in xrange((4*i),(4*i+4)):
			if(j<12 and j==0 or j==4 or j==8):
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
			if(j>11 and j<24 and j==15 or j==19 or j==23):
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
			if(j>23 and j<36 and j==24 or j==28 or j==32):
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
			if(j>35 and j<48 and j==39 or j==43 or j==47):
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
	return