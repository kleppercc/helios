#pragma rtGlobals=1		// Use modern global access method.
Function load_HELIOS(shot, GainCorrYN)
	variable shot
	variable GainCorrYN
	
	Variable cleanYN=1 //Hard code in for now
	
	variable i
	SetDataFolder root:
	//NewPath/O/Q TEXTORdata "TravelTronSSD:Users:unterbee:Desktop:TEXTOR_data:"
	NewPath/O/Q TEXTORdata "MainSSD:Users:unterbee:Desktop:TEXTOR_data:"
	
	string folder
	folder = "s"+num2istr(shot)
	if(DataFolderExists(folder) ==1)
		KillDataFolder/Z folder
	endif

	Variable fileID	
	HDF5OpenFile/P=TEXTORdata/R/Z fileID as folder+".h5"
	HDF5LoadGroup/T/O/Z :, fileID, "/"			
	HDF5CloseFile/A/Z fileID
	
	if(GainCorrYN ==1)
		SetDataFolder folder
		Wave NumPnts0,DEL_t,t_Delay,t_Trigger
		
		Make/O/N=(NumPnts0[0]) TimeBase
		TimeBase = (del_t*p)-abs(t_Trigger[0]+t_Delay[0])
		
		Wave OpAmpGain_Arr
		Variable NumTubes
		NumTubes = numpnts(OpAmpGain_Arr)
		
		Make/O/N=(NumTubes) CRTL_Arr
		
		String TubeNam, GainPMTNam, PhotoElNam, CrtlNam, W_Wave
		Variable Gain, DynodeGain
		for(i=0; i<(NumTubes);i+=1)
				Gain =OpAmpGain_Arr[i] 
				if (i<9)
					TubeNam = "VOLT_TUBE0"+num2str(i+1)
					GainPMTNam = "G_PMT_TUBE0"+num2str(i+1)
					PhotoElNam = "PhEl_TUBE0"+num2str(i+1)
					CrtlNam = "CRTL_TUBE0"+num2str(i+1)
					W_Wave = "W_coef_0"+num2str(i+1)
				else
					TubeNam = "VOLT_TUBE"+num2str(i+1)
					GainPMTNam = "G_PMT_TUBE"+num2str(i+1)
					PhotoElNam = "PhEl_TUBE"+num2str(i+1)
					CrtlNam = "CRTL_TUBE"+num2str(i+1)
					W_Wave = "W_coef_"+num2str(i+1)
				endif
				
				Duplicate/O $TubeNam, $GainPMTNam, $PhotoElNam
				Wave dum1 = $GainPMTNam
				Wave dum2 = $TubeNam
				Wave/SDFR=root: W_Dum=$W_wave
				CRTL_Arr[i] = mean($CrtlNam)
				
				DynodeGain = Poly(W_Dum,CRTL_Arr[i])

				Wave dum3 = $PhotoElNam
				
				dum1 = (dum2/Gain)
				dum3 =  dum1/exp(DynodeGain)
				
				if(cleanYN==1)
					KillWaves/Z dum1
				endif
				Redimension/S $TubeNam
				Redimension/S $PhotoElNam
		endfor

	endif
	SetDataFolder root:
End