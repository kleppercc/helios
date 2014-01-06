import time
import numpy as np


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

def makeChanDICT():

	chWav = []
	for i in xrange(start,stop):
		chWav.append('CH'+str(i))
	suf1 = '_R668728'
	suf2 = '_R728706'
	chanDICT ={}
	for i in chWav:
		chanDICT[chWav[i]+suf1] = 0.0
		chanDICT[chWav[i]+suf2] = 0.0

	return ChanDICT

def truncWavs(tIndex,tBase_L,ChanDICT):
	return
