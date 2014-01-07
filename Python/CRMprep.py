import time
import numpy as np
import pandas as pds
import helios.Python.get_HELIOS_v2 as getHEL
import helios.Python.palop as palop

reload(getHEL)

def loadtoPDS(SHOT,tubeNUM=48,quiet=True):
	outDICT = getHEL.grab(SHOT,tubeNUM,make_raw=False,make_tBase=True,quiet=quiet)
	fluxARR = pds.DataFrame(outDICT['FILTFLUX_array'],index=outDICT['tBase'][:-1])
	for i in xrange(tubeNUM):
		fluxARR[i].name = outDICT['PMTDESC_array'][i]
	headerDICT = {'shot':outDICT['shot'],'t_Delay':outDICT['t_Delay'],'Samples':outDICT['Samples'],
					't_Trigger':outDICT['t_Trigger'],'DEL_t':outDICT['DEL_t']}
	return fluxARR, headerDICT

def makWavs(fluxARR,headerDICT,tubeNUM=48,baseNum=1000.,pntsm=5,interppnt=5,frac=0.01,quiet=True):
	tottime = np.abs(fluxARR[0].index[-1])-np.abs(fluxARR[0].index[0])

	newARR = pds.stats.moments.rolling_mean(fluxARR,baseNum)

	for i in xrange(tubeNUM):
		newARR[i].name = fluxARR[i].name+'_L'

	return newARR

def getTimes(y_she_corr, x_she1):

	ind = np.where(y_she_corr > 0.5)
	tValues = x_she1[ind]

	return tValues

def findIndex(tValues,tBase_L_fix):

	temp = ()
	for i in tValues:
		hold = tValues[i]
		holder = np.argmin(np.abs(tBase_L_fix - hold))
		temp = np.append(temp,holder)

	tIndex = ()

	for i in temp:
		if(temp[i] != temp[i-1]):
			temp2 = temp[i]
			tIndex = np.append(tIndex, temp2)

	return tIndex

# def makeChanDICT():

# 	chWav = []
# 	for i in xrange(start,stop):
# 		chWav.append('CH'+str(i))
# 	suf1 = '_R668728'
# 	suf2 = '_R728706'
# 	chanDICT ={}
# 	for i in chWav:
# 		chanDICT[chWav[i]+suf1] = 0.0
# 		chanDICT[chWav[i]+suf2] = 0.0

# 	return ChanDICT

def truncWavs(tIndex,tBase_L,ChanDICT):
	return
