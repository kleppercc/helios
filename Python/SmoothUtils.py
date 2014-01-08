#SmoothUtils
import numpy as np
import pandas as pds

def Takeoff_bac(wav,tubeNum,pntsm,interppnt,frac=50,quiet=True):
	if not quiet:
		print 'here'
		wavNum = wav.shape[1]
		for i in xrange(wavNum):
			print wav[i].name
	wav2 = Get_back(wav,tubeNum,pntsm,frac)
	wav4 = pds.stats.moments.rolling_min(wav2,interppnt)
	# wav4 = PerctSmooth(wav2,wav2.index[0],wav2.index[-1],frac=10)
	OutWav = wav - wav4
	return OutWav

def Get_back(wav,tubeNum,pntsm,frac):
	wavpnts = len(wav)
	for i in xrange(tubeNum):
		if i == 0:
			wav2 = pds.DataFrame(wav[i],index=wav[i].index)
			wav2.columns = [i]
		else:
			wav2[i] = wav[i]
		print wav[i].name
		wav2[i].name = wav[i].name+'_bac'
	for i in xrange(0,wavpnts,pntsm):
		result = PerctSmooth(wav,i,(i+pntsm),frac)
		wav2[i:(i+pntsm)] = result.value
	return wav2

def PerctSmooth(inWav,start,end,frac,stddev=False):
	hold = inWav[start:end]
	outWav = inWav.copy()
	outWav.value = np.percentile(hold,frac,overwrite_input=False)
	if stddev:
		stddevWav = np.std(outWav)
		return outWav, stddevWav
	else:
		return outWav