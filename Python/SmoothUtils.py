#SmoothUtils
import numpy as np
import pandas as pds

def Takeoff_bac(wav,pntsm,interppnt,frac,quiet=True):
	if not quiet:
		print 'Takeoff_bac t1: {}'.format(wav.name)
	wav2 = Get_back(wav,pntsm,frac)
	wav4 = pds.stats.moments.rolling_min(wav2,interppnt)
	wav4 = wav4.fillna(0)
	OutWav = wav.sub(wav4)
	if not quiet:
		print 'Takeoff_bac t2: {}'.format(OutWav)
	return OutWav

def Get_back(wav,pntsm,frac):
	wavpnts = len(wav)
	wav2 = pds.Series(wav)
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