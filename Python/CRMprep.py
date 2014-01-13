import numpy as np
import pandas as pds
import helios.Python.get_HELIOS_v2 as getHEL
import helios.Python.SmoothUtils as SmU
import helios.Python.getSHOT as gST
reload(getHEL)
reload(SmU)
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
			hold = SmU.smoothWavs(newARR_Short[i],stdev=smstdev,quiet=quiet,debug=debug)
			listHolder1.append(pds.Series(data=hold.values,index=hold.index,name=hold.name))
		newARR_sh_sm = pds.DataFrame(listHolder1).T
		holdNam = newARR_sh_sm.columns
		newARR_sh_sm.columns = np.arange(tubeNUM)
		if not quiet:
			print 'Done: smoothWavs  : Sehr Gut'
		# need to clean up the name versus column mess.
		for i in xrange(tubeNUM):
			newARR_sh_sm[i].name = holdNam[i]
		if debug and not quiet:
			for i in xrange(tubeNUM):
				print 'makWavs t2: {}'.format(newARR_sh_sm[i].name)
		listHolder2=[]
		for j in xrange(tubeNUM):
			listHolder2.append(pds.Series(SmU.Takeoff_bac(newARR_sh_sm[j],pntsm=bacPNTSM,interppnt=bacinterppnt,frac=bacfrac,quiet=quiet,debug=debug),name = newARR_sh_sm[j].name+'_bac'))
		newARR_backoff = pds.DataFrame(listHolder2).T
		holdNam = newARR_backoff.columns
		newARR_backoff.columns = np.arange(tubeNUM)
		# ditto to above
		for i in xrange(tubeNUM):
			newARR_backoff[i].name = holdNam[i]
		if debug and not quiet:
			for k in xrange(tubeNUM):
				print 'makWavs t3: {}'.format(newARR_backoff[k].name)
		if not quiet:
			print "Done: backoff Waves  : Sehr Gut"
	else:
		listHolder2=[]
		for j in xrange(tubeNUM):
			listHolder2.append(pds.Series(SmU.Takeoff_bac(newARR_Short[j],pntsm=bacPNTSM,interppnt=bacinterppnt,frac=bacfrac,quiet=quiet,debug=debug),name = newARR_Short[j].name+'_bac'))
		newARR_backoff = pds.DataFrame(listHolder2).T
		holdNam = newARR_backoff.columns
		newARR_backoff.columns = np.arange(tubeNUM)
		# ditto to above
		for i in xrange(tubeNUM):
			newARR_backoff[i].name = holdNam[i]
			if debug and not quiet:
				print 'makWavs t4: {}'.format(newARR_backoff[i].name)
		if not quiet:
			print "Done: backoff Waves  : Sehr Gut"
	if not quiet:
		print 'Downsampled signals are {:.1} Hz'.format(newARR_Short.shape[0]/tottime)
	return newARR_Short,newARR_sh_sm,newARR_backoff

def truncWavs(shot,chanDFram,fnamH5,truncVal=0.95,debug=False,quiet=True):
	wavNum = chanDFram.shape[1]
	tVal,_ = getTimes(shot,fnamH5,truncVal=truncVal)
	wavIND = findIndex(tVal,chanDFram[0].index,quiet=quiet)

	listHolder=[]
	for i in xrange(wavNum):
		listHolder.append(pds.Series(chanDFram[i][wavIND].values,index=chanDFram[i][wavIND].index,name = chanDFram[i].name+'_fin'))
	newARR_trunc = pds.DataFrame(listHolder).T
	holdNam = newARR_trunc.columns
	newARR_trunc.columns = np.arange(wavNum)
	# ditto to above
	for j in xrange(wavNum):
		newARR_trunc[j].name = holdNam[j]
		if debug and not quiet:
			print 'truncWavs t1: {}'.format(newARR_trunc[j].name)
	if not quiet:
		print 'truncWavs: Done : Sehr Gut'
	return newARR_trunc

def getTimes(shot,fnamH5,truncVal=0.9,fnamMAT=None,load2HDF=False,fixSHE=True,quiet=True,debug=False):
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
		ind = np.where((dataDICT['y_she_corr']/dataDICT['y_she_corr'].max()) > truncVal)
	else:
		ind = np.where((dataDICT['y_she1']/dataDICT['y_she1'].max()) > truncVal)
	tValues = dataDICT['x_she_corr'][ind]
	if debug and not quiet:
		print "num data, num trunc {} {}".format(dataDICT['x_she_corr'].shape,tValues.shape)
	return tValues,ind


def findIndex(tValues,tBase_IN,quiet=True):
	inWAV = np.asarray(tBase_IN)
	temp = ()
	for i in xrange(len(tValues)):
		hold = tValues[i]
		holder = np.argmin(np.abs(inWAV - hold))
		temp = np.append(temp,holder)

	WavtIndex = ()
	for i in xrange(len(temp)):
		if(temp[i] != temp[i-1]):
			temp2 = temp[i]
			WavtIndex = np.append(WavtIndex, temp2)
	return WavtIndex.astype(int)
