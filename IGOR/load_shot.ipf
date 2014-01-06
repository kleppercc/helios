#pragma rtGlobals=1		// Use modern global access method.
Function load_Shot(shot,path)
	variable shot
	string path
	
	variable i
	SetDataFolder root:
       NewPath/O/Q TEXTORdata path
//	NewPath/O/Q TEXTORdata "TravelTronSSD:Users:unterbee:Desktop:TEXTOR_HELIOS:"
//	NewPath/O/Q TEXTORdata "MainSSD:Users:unterbee:Desktop:TEXTOR_data:"
	
	string folder
	folder = "HELIOSFS_"+num2istr(shot)
	if(DataFolderExists(folder) ==1)
		KillDataFolder/Z folder
	endif

	Variable fileID	
	HDF5OpenFile/P=TEXTORdata/R/Z fileID as folder+".h5"
	HDF5LoadGroup/T/O/Z :, fileID, "/"			
	HDF5CloseFile/A/Z fileID
	
	SetDataFolder folder
	Wave DEL_t,t_Delay,t_Trigger	
	
	Wave FILTFLUX_array		
	SetScale/P x (t_Trigger[0]+t_Delay[0]),DEL_t[0],"sec", FILTFLUX_array
		
	SetDataFolder root:
End

Function/S ExecutePythonShellCommand(printCommandInHistory, printResultInHistory,makeraw,maketbase,chans,shot)
	Variable printCommandInHistory
	Variable printResultInHistory
	Variable makeraw
	Variable maketbase
	Variable chans
	Variable shot

	Variable write_files = 1
	Variable quiet = 0
	String uCommand =". ${HOME}/.bash_profile; python Users/unterbee/helios/Python/get_HELIOS_4IGOR.py" 
	uCommand = uCommand+" "+num2istr(makeraw)+" "+num2istr(maketbase)+" "+num2istr(write_files)+" "+num2istr(quiet)+" "+num2istr(chans)+" "+num2istr(shot)
	if (printCommandInHistory)
		printf "Unix command: %s\r", uCommand
	endif

	String cmd
	sprintf cmd, "do shell script \"%s\"", uCommand
	ExecuteScriptText cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End