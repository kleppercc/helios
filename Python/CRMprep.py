import time
import numpy as np
import pandas as pds
import helios.Python.get_HELIOS_v2 as getHEL
import helios.Python.palop as palop
import helios.Python.SmoothUtils as SmU
import helios.Python.getSHOT as gST

reload(getHEL)
reload(SmU)
reload(palop)
reload(gST)

def loadtoPDS(SHOT,tubeNUM=48,quiet=True):
	outDICT = getHEL.grab(SHOT,tubeNUM,make_raw=False,make_tBase=True,quiet=quiet)
	fluxARR = pds.DataFrame(outDICT['FILTFLUX_array'],index=outDICT['tBase'][:-1])
	for i in xrange(tubeNUM):
		fluxARR[i].name = outDICT['PMTDESC_array'][i]
	headerDICT = {'shot':outDICT['shot'],'t_Delay':outDICT['t_Delay'],'Samples':outDICT['Samples'],
					't_Trigger':outDICT['t_Trigger'],'DEL_t':outDICT['DEL_t']}
	return fluxARR, headerDICT

def makWavs(fluxARR,headerDICT,tubeNUM=48,baseNum=100,smstdev=7,bacPNTSM=5,bacinterppnt=150,bacfrac=30,smoothTF=True,quiet=True,debug=False):
	baseNum = int(baseNum)
	tottime = np.abs(fluxARR[0].index[-1])-np.abs(fluxARR[0].index[0])
	newARR = pds.stats.moments.rolling_mean(fluxARR,baseNum)
	newARR = newARR.fillna(newARR.index[1])
	newARR_Short = newARR[::baseNum]
	for i in xrange(tubeNUM):
		newARR_Short[i].name = fluxARR[i].name+'_L'
		if debug and not quiet:
			print 'makWavs t1: {}'.format(newARR_Short[i].name)
	if smoothTF:
		listHolder1=[]
		for i in xrange(tubeNUM):
			hold = smoothWavs(newARR_Short[i],stdev=smstdev,quiet=quiet,debug=debug)
			listHolder1.append(pds.Series(data=hold.values,index=hold.index,name=hold.name))
		newARR_sh_sm = pds.DataFrame(listHolder1).T
		holdNam = newARR_sh_sm.columns
		newARR_sh_sm.columns = np.arange(tubeNUM)
		# need to clean up the name versus column mess.
		for i in xrange(tubeNUM):
			newARR_sh_sm[i].name = holdNam[i]
		if debug and not quiet:
			for i in xrange(tubeNUM):
				print 'makWavs t2: {}'.format(newARR_sh_sm[i].name)
		listHolder2=[]
		for j in xrange(tubeNUM):
			listHolder2.append(pds.Series(SmU.Takeoff_bac(newARR_sh_sm[j],pntsm=bacPNTSM,interppnt=bacinterppnt,frac=bacfrac,quiet=quiet),name = newARR_sh_sm[j].name+'_bac'))
		newARR_backoff = pds.DataFrame(listHolder2).T
		holdNam = newARR_backoff.columns
		newARR_backoff.columns = np.arange(tubeNUM)
		# ditto to above
		for i in xrange(tubeNUM):
			newARR_backoff[i].name = holdNam[i]
		if debug and not quiet:
			for k in xrange(tubeNUM):
				print 'makWavs t3: {}'.format(newARR_backoff[k].name)
	else:
		listHolder2=[]
		for j in xrange(tubeNUM):
			listHolder2.append(pds.Series(SmU.Takeoff_bac(newARR_Short[j],pntsm=pntsm,interppnt=interppnt,frac=frac,quiet=quiet),name = newARR_Short[j].name+'_bac'))
		newARR_backoff = pds.DataFrame(listHolder2).T
		holdNam = newARR_backoff.columns
		newARR_backoff.columns = np.arange(tubeNUM)
		# ditto to above
		for i in xrange(tubeNUM):
			newARR_backoff[i].name = holdNam[i]
		if debug and not quiet:
			for k in xrange(tubeNUM):
				print 'makWavs t4: {}'.format(newARR_backoff[k].name)
	print 'Downsampled signals are {:.1} Hz'.format(newARR_Short.shape[0]/tottime)
	return newARR_Short,newARR_sh_sm,newARR_backoff

def smoothWavs(wav,stdev=None,quiet=True,debug=False):
	if stdev == None:
		stdev = 7
	wavSM = pds.Series(palop.smooth(wav,stdev),index=wav.index)
	wavSM.name = wav.name+'_palop'
	if debug and not quiet:
		print 'smoothWavs t1: {}'.format(wavSM.name)
	return wavSM

def getTimes(shot,fnamH5,fnamMAT=None,load2HDF=False,fixSHE=True,quiet=True,debug=False):
	
	if load2HDF:
		if fnamMAT == None:
			fnamMAT='/Users/unterbee/Desktop/shot_118800.mat'
		gST.getShotmat(118800,fnamMAT)
	
	dataDICT = gST.load2DICT(fnamH5)
	if fixSHE:
		oldX=dataDICT['x_she1']
		oldY=dataDICT['y_she1']
		dataDICT['x_she_corr']=oldX[:]+0.04
		dataDICT['y_she_corr']=oldY[:]-np.mean(oldY[0:10])
		ind = np.where((dataDICT['y_she_corr']/dataDICT['y_she_corr'].max()) > 0.5)
	else:

		ind = np.where((dataDICT['y_she1']/dataDICT['y_she1'].max()) > 0.5)
	# tValues = x_she1[ind]

	return dataDICT
	# return tValues

# Function GetTimes()
	
# 	Wave y_she_corr
# 	Wave x_she1
	
# 	Make/n=1/o tValues,temp
# 	Wavestats/Q x_she1
# 	Variable i, hold
# 	for(i=0;i<V_npnts;i+=1)
# 		hold=y_she_corr[i]
# 		if(hold>0.5)
# 			temp = x_she1[i]
# 			Concatenate/NP {temp},tValues
# 		endif
# 	endfor
# 	DeletePoints 0,1,tValues
# 	KillWaves/Z temp
# End

# Function FindIndex()
	
# 	DFREF dREF = root:s118794_wavs
# 	Wave/SDFR=dREF tValues
	
# 	Make/n=1 holder
	
# 	WaveStats/Q tValues
# 	Variable i,hold
# 	for(i=0;i<V_npnts;i+=1)
# 		hold = tValue[i]
# 		FindValue/V=hold/T=1e-2 tBase_L
# 	endfor
# End

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