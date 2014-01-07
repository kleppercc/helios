#SmoothUtils

Function Takeoff_bac(pntsm,interppnt,wav,twav,frac)
	Variable pntsm
	Variable interppnt
	String wav
	Wave twav
	Variable frac
	
	Wave wav1 = $wav
	
	Get_back(wav,pntsm,frac)
	
	String neuwav = wav+"_bac"
	Wave wav2 = $neuwav
	
	String finalwav = wav[0,11]+"_fin"
	String tempwav =  wav[0,11]+"_temp"
	
	Duplicate/O wav1 $finalwav, $tempwav
	Wave wav3 = $finalwav
	Wave wav4 = $tempwav
	
	WaveStats/Q $wav
	Variable Nums = V_npnts
	Interpolate2/T=1/N=(Nums)/A=(interppnt)/J=0/Y=wav4 twav, wav2

	wav3 = wav1 - wav4
	
	KillWaves wav2,wav4
end

def Get_back(wav,pntsm,frac):
	wavpnts = len(wav)
	wav2 = wav.copy()
	wav2.name = wav.name+'_bac'
	for iin xrange(0,wavpnts,pntsm):
		result = PerctSmooth(neuwav,i,(i+pntsm))
		wav2[i:(i+pntsm)] = result.value
	return wav2

def PerctSmooth(inWav,start,end,frac,stddev=False):
	hold = inWav[start:end]
	outWav.value = np.percentile(hold,frac,overwrite_input=False, interpolation='linear')
	if stddev:
		stddevWav = np.std(outWav)
		return outWav, stddevWav
	else:
		return outWav
