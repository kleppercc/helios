import time
import numpy as np
import pandas as pds
import helios.Python.get_HELIOS_v2 as getHEL
import helios.Python.palop as palop
import helios.Python.SmoothUtils as SmU

reload(getHEL)
reload(SmU)
reload(palop)

def loadtoPDS(SHOT,tubeNUM=48,quiet=True):
	outDICT = getHEL.grab(SHOT,tubeNUM,make_raw=False,make_tBase=True,quiet=quiet)
	fluxARR = pds.DataFrame(outDICT['FILTFLUX_array'],index=outDICT['tBase'][:-1])
	for i in xrange(tubeNUM):
		fluxARR[i].name = outDICT['PMTDESC_array'][i]
	headerDICT = {'shot':outDICT['shot'],'t_Delay':outDICT['t_Delay'],'Samples':outDICT['Samples'],
					't_Trigger':outDICT['t_Trigger'],'DEL_t':outDICT['DEL_t']}
	return fluxARR, headerDICT

def makWavs(fluxARR,headerDICT,tubeNUM=48,baseNum=100,pntsm=100,interppnt=150,frac=30,smoothTF=True,quiet=True):
	baseNum = int(baseNum)
	# tottime = np.abs(fluxARR[0].index[-1])-np.abs(fluxARR[0].index[0])
	newARR = pds.stats.moments.rolling_mean(fluxARR,baseNum)
	newARR = newARR.fillna(newARR.index[1])
	newARR_Short = newARR[::baseNum]
	for i in xrange(tubeNUM):
		newARR_Short[i].name = fluxARR[i].name+'_L'
		print 'makWavs test1: '+newARR_Short[i].name
	if smoothTF:
		for i in xrange(tubeNUM):
			if i == 0:
				newARR_sh_sm = smoothWavs(newARR_Short[i],tubeNum=tubeNUM,quiet=quiet)
				newARR_sh_sm.columns =[i]
			else:
				newARR_sh_sm[i] = smoothWavs(newARR_Short[i],quiet=quiet)
		if not quiet:
			print 'makWavs test2: {}'.format(newARR_sh_sm[i].name)
		newARR_backoff = SmU.Takeoff_bac(newARR_sh_sm,tubeNUM,pntsm=pntsm,interppnt=interppnt,frac=30,quiet=quiet)
		# newARR_backoff = newARR_sh_sm.copy(False)
		# for i in xrange(tubeNUM):
			# newARR_backoff[i].name = newARR_sh_sm[i].name+'_bac'
	else:
		newARR_backoff = SmU.Takeoff_bac(newARR_Short,tubeNUM,pntsm=pntsm,interppnt=interppnt,frac=30)
		for i in xrange(tubeNUM):
			newARR_backoff[i].name = newARR_Short[i].name+'_bac'
	return newARR_Short,newARR_backoff

def smoothWavs(wav,tubeNum,sampwid=4000,stdev=7,quiet=True):
	for i in xrange(tubeNum):
		if i == 0:
			wavSM = pds.DataFrame(wav[i],index=wav[i].index)
			wavSM.columns = [i]
		else:
			wavSM[i] = wav[i]
		wavSM[i] = palop.smooth(wav[i],sampwid,stdev)
		wavSM[i].name = wav[i].name+'_palop'
		if not quiet:
			print 'smoothWavs test: {}'.format(wavSM[i].name)
	return wavSM

def getTimes(y_she_corr, x_she1):

	ind = np.where(y_she_corr > 0.5)
	tValues = x_she1[ind]

	return tValues

# def findIndex(tValues,tBase_L_fix):

# 	temp = ()
# 	for i in tValues:
# 		hold = tValues[i]
# 		holder = np.argmin(np.abs(tBase_L_fix - hold))
# 		temp = np.append(temp,holder)

# 	tIndex = ()

# 	for i in temp:
# 		if(temp[i] != temp[i-1]):
# 			temp2 = temp[i]
# 			tIndex = np.append(tIndex, temp2)

# 	return tIndex

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

# def truncWavs(tIndex,tBase_L,ChanDICT):
	# return