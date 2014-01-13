import numpy as np
import pandas as pds

def run(shot,HeliosDFram,CHDsetNum=6,CHDpath='/Users/unterbee/Dropbox/HELIOS Master/20140111',debug=False,quiet=True):
	# Don't this the CHDwavBas is needed.
	# CHDwavBase = np.genfromtxt(CHDpath+'/Chd_num.txt',skip_header=1,dtype=str)
	CHDsetupNum = np.genfromtxt(CHDpath+'/CHORDsetups.txt',skip_header=1,dtype=int,unpack=True)
	CHDNumHold = CHDsetupNum[CHDsetNum]
	if np.any((CHDNumHold > 200)):
		CHDNumHold = CHDNumHold-200
	prefix = 'CHD'
	suffix1 = '_R728706'
	suffix2 = '_R668728'

	smStart = 10
	smNum = 10.
	smEnd = smStart+smNum

	listHolder = []
	for i in xrange(12):
		for j in xrange((4*i),(4*i+4)):
			if(j<12 and j==0 or j==4 or j==8):
				holdWav1 = HeliosDFram[j]
				holdWav2 = HeliosDFram[j+1]
				holdWav3 = HeliosDFram[j+2]
				ratioHold1 =  holdWav1/holdWav2
				ratioHold2 = holdWav3/holdWav1
				wavSTR1 = prefix+str(CHDNumHold[i])+suffix1
				wavSTR2 = prefix+str(CHDNumHold[i])+suffix2
				listHolder.append(pds.Series(ratioHold1.values,index=ratioHold1.index,name=wavSTR1))
				listHolder.append(pds.Series(ratioHold2.values,index=ratioHold2.index,name=wavSTR2))
				if debug and not quiet:
					print 'NAMES: {} {}'.format(wavSTR1,wavSTR2)
			if(j>11 and j<24 and j==15 or j==19 or j==23):
				holdWav1 = HeliosDFram[j]
				holdWav2 = HeliosDFram[j-1]
				holdWav3 = HeliosDFram[j-2]
				ratioHold1 =  holdWav1/holdWav2
				ratioHold2 = holdWav3/holdWav1
				wavSTR1 = prefix+str(CHDNumHold[i])+suffix1
				wavSTR2 = prefix+str(CHDNumHold[i])+suffix2
				if debug and not quiet:
					print 'NAMES: {} {}'.format(wavSTR1,wavSTR2)
				listHolder.append(pds.Series(ratioHold1.values,index=ratioHold1.index,name=wavSTR1))
				listHolder.append(pds.Series(ratioHold2.values,index=ratioHold2.index,name=wavSTR2))
			if(j>23 and j<36 and j==24 or j==28 or j==32):
				holdWav1 = HeliosDFram[j]
				holdWav2 = HeliosDFram[j+1]
				holdWav3 = HeliosDFram[j+2]
				ratioHold1 =  holdWav1/holdWav2
				ratioHold2 = holdWav3/holdWav1
				wavSTR1 = prefix+str(CHDNumHold[i])+suffix1
				wavSTR2 = prefix+str(CHDNumHold[i])+suffix2
				listHolder.append(pds.Series(ratioHold1.values,index=ratioHold1.index,name=wavSTR1))
				listHolder.append(pds.Series(ratioHold2.values,index=ratioHold2.index,name=wavSTR2))
				if debug and not quiet:
					print 'NAMES: {} {}'.format(wavSTR1,wavSTR2)
			if(j>35 and j<48 and j==39 or j==43 or j==47):
				holdWav1 = HeliosDFram[j]
				holdWav2 = HeliosDFram[j-1]
				holdWav3 = HeliosDFram[j-2]
				ratioHold1 =  holdWav1/holdWav2
				ratioHold2 = holdWav3/holdWav1
				wavSTR1 = prefix+str(CHDNumHold[i])+suffix1
				wavSTR2 = prefix+str(CHDNumHold[i])+suffix2
				listHolder.append(pds.Series(ratioHold1.values,index=ratioHold1.index,name=wavSTR1))
				listHolder.append(pds.Series(ratioHold2.values,index=ratioHold2.index,name=wavSTR2))
				if debug and not quiet:
					print 'NAMES: {} {}'.format(wavSTR1,wavSTR2)
	wavNum = len(listHolder)
	newARR = pds.DataFrame(listHolder).T
	holdNam = newARR.columns
	newARR.columns = np.arange(wavNum)
	for j in xrange(wavNum):
		newARR[j].name = holdNam[j]
		if debug and not quiet:
			print 'makRATIO t1: {}'.format(newARR[j].name)
	if not quiet:
		print 'makRATIO: Done : Sehr Gut'
	return newARR