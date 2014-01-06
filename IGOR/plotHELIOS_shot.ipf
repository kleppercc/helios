#pragma rtGlobals=1		// Use modern global access method.

Macro Plot_HELIOS_Shot(Shot, loaddat,ratioYN)
	Variable shot
	Variable loaddat
	Variable ratioYN
	
	SetDataFolder root:
	
	if(loaddat == 1)
		Variable corr4Gains=1
		Print "Getting Data"
		load_HELIOS(shot,corr4Gains)
	endif
	
	string folder
	folder = "s"+num2istr(shot)
	SetDataFolder folder
	
	Variable binfactor = 750
		
	Variable NewPnts = (NumPnts0[0]/binfactor)
	String PhEl_Int,PhotoElNam
	Variable i
	Variable NumTubes = numpnts(OpAmpGain_Arr)
	Variable MeanVal
	i=0
	Duplicate/O timebase, timebase_L
	Print "Now loading smoothed Sigs."
	print "With integration time of: "+num2str(1/newpnts)
	do		
		if (i<9)
			PhotoElNam = "PhEl_TUBE0"+num2str(i+1)
			PhEl_Int="PhEl_TUBE0"+num2str(i+1)+"_L"
		else
			PhotoElNam = "PhEl_TUBE"+num2str(i+1)
			PhEl_Int="PhEl_TUBE"+num2str(i+1)+"_L"
		endif
			
		MeanVal = mean($PhotoelNam,0,20000)
		$PhotoelNam -=MeanVal
			
		if(i==0)
			Interpolate2/T=1/N=(NewPnts)/A=(NewPnts)/J=2/Y=$PhEl_Int/X=timebase_L timebase, $PhotoElNam
		else
			Interpolate2/T=1/N=(NewPnts)/A=(NewPnts)/J=2/Y=$PhEl_Int $PhotoElNam
		endif
		Redimension/S $PhEl_Int,timebase_L
		i+=1
	while (i < (NumTubes))
	
	PauseUpdate; Silent 1
	Display /W=(45,45,767,1141)
	
	Display/W=(0.2,0,0.5,0.167)/FG=(FL,,,)/HOST=# PhEl_TUBE01_l vs timebase_l
	AppendToGraph PhEl_TUBE02_l vs timebase_l
	AppendToGraph PhEl_TUBE03_l vs timebase_l
	AppendToGraph PhEl_TUBE04_l vs timebase_l
	String wave1=DescTex_arr[0]
	String wave2=DescTex_arr[1]
	String wave3=DescTex_arr[2]
	String wave4=DescTex_arr[3]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE02_l)=(0,0,0),rgb(PhEl_TUBE03_l)=(1,16019,65535),rgb(PhEl_TUBE04_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23 "\\F'Arial Unicode MS'\\Z12\\f01Chord #1 Signals\r\\s(PhEl_TUBE01_l) "+wave1+"\r\\s(PhEl_TUBE02_l) "+wave2
	AppendText "\\s(PhEl_TUBE03_l) "+wave3+"\r\\s(PhEl_TUBE04_l) "+wave4
	TextBox/C/N=text1/F=0/B=1/A=MC/X=-11/Y=42 "\\f01\\F'Arial Unicode MS'\\Z14Shot "+num2istr(shot)
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.2,0.167,0.5,0.334)/FG=(FL,,,)/HOST=# PhEl_TUBE05_l vs timebase_l
	AppendToGraph PhEl_TUBE06_l vs timebase_l
	AppendToGraph PhEl_TUBE07_l vs timebase_l
	AppendToGraph PhEl_TUBE08_l vs timebase_l
	wave1=DescTex_arr[4]
	wave2=DescTex_arr[5]
	wave3=DescTex_arr[6]
	wave4=DescTex_arr[7]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE06_l)=(0,0,0),rgb(PhEl_TUBE07_l)=(1,16019,65535),rgb(PhEl_TUBE08_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23 "\\F'Arial Unicode MS'\\Z12\\f01Chord #2 Signals\r\\s(PhEl_TUBE05_l) "+wave1+"\r\\s(PhEl_TUBE06_l) "+wave2
	AppendText "\\s(PhEl_TUBE07_l) "+wave3+"\r\\s(PhEl_TUBE08_l) "+wave4
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.2,0.334,0.5,0.5)/FG=(FL,,,)/HOST=# PhEl_TUBE09_l vs timebase_l
	AppendToGraph PhEl_TUBE10_l vs timebase_l
	AppendToGraph PhEl_TUBE11_l vs timebase_l
	AppendToGraph PhEl_TUBE12_l vs timebase_l
	wave1=DescTex_arr[8]
	wave2=DescTex_arr[9]
	wave3=DescTex_arr[10]
	wave4=DescTex_arr[11]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE10_l)=(0,0,0),rgb(PhEl_TUBE11_l)=(1,16019,65535),rgb(PhEl_TUBE12_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23 "\\F'Arial Unicode MS'\\Z12\\f01Chord #3 Signals\r\\s(PhEl_TUBE09_l) "+wave1+"\r\\s(PhEl_TUBE10_l) "+wave2
	AppendText "\\s(PhEl_TUBE11_l) "+wave3+"\r\\s(PhEl_TUBE12_l) "+wave4
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0,1,0.167)/HOST=# PhEl_TUBE16_l vs timebase_l
	AppendToGraph PhEl_TUBE15_l vs timebase_l
	AppendToGraph PhEl_TUBE14_l vs timebase_l
	AppendToGraph PhEl_TUBE13_l vs timebase_l
	wave1=DescTex_arr[12]
	wave2=DescTex_arr[13]
	wave3=DescTex_arr[14]
	wave4=DescTex_arr[15]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE15_l)=(0,0,0),rgb(PhEl_TUBE14_l)=(1,16019,65535),rgb(PhEl_TUBE13_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #4 Signals\r\\s(PhEl_TUBE16_l) "+wave4+"\r\\s(PhEl_TUBE15_l) "+wave3
	AppendText "\\s(PhEl_TUBE14_l) "+wave2+"\r\\s(PhEl_TUBE13_l) "+wave1
	TextBox/C/N=text1/F=0/B=1/A=MC/X=-11/Y=42 "\\f01\\F'Arial Unicode MS'\\Z14Shot "+num2istr(shot)
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0.167,1,0.334)/HOST=#   PhEl_TUBE20_l vs timebase_l
	AppendToGraph PhEl_TUBE19_l vs timebase_l
	AppendToGraph PhEl_TUBE18_l vs timebase_l
	AppendToGraph PhEl_TUBE17_l vs timebase_l
	wave1=DescTex_arr[16]
	wave2=DescTex_arr[17]
	wave3=DescTex_arr[18]
	wave4=DescTex_arr[19]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE19_l)=(0,0,0),rgb(PhEl_TUBE18_l)=(1,16019,65535),rgb(PhEl_TUBE17_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #5 Signals\r\\s(PhEl_TUBE20_l) "+wave4+"\r\\s(PhEl_TUBE19_l) "+wave3
	AppendText "\\s(PhEl_TUBE18_l) "+wave2+"\r\\s(PhEl_TUBE17_l) "+wave1
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0.334,1,0.5)/HOST=#   PhEl_TUBE24_l vs timebase_l
	AppendToGraph PhEl_TUBE23_l vs timebase_l
	AppendToGraph PhEl_TUBE22_l vs timebase_l
	AppendToGraph PhEl_TUBE21_l vs timebase_l
	wave1=DescTex_arr[20]
	wave2=DescTex_arr[21]
	wave3=DescTex_arr[22]
	wave4=DescTex_arr[23]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE23_l)=(0,0,0),rgb(PhEl_TUBE22_l)=(1,16019,65535),rgb(PhEl_TUBE21_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #6 Signals\r\\s(PhEl_TUBE24_l) "+wave4+"\r\\s(PhEl_TUBE23_l) "+wave3
	AppendText "\\s(PhEl_TUBE22_l) "+wave2+"\r\\s(PhEl_TUBE21_l) "+wave1
	RenameWindow #,G5
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.2,0.5,0.5,0.667)/FG=(FL,,,)/HOST=#   PhEl_TUBE25_l vs timebase_l
	AppendToGraph PhEl_TUBE26_l vs timebase_l
	AppendToGraph PhEl_TUBE27_l vs timebase_l
	AppendToGraph PhEl_TUBE28_l vs timebase_l
	wave1=DescTex_arr[24]
	wave2=DescTex_arr[25]
	wave3=DescTex_arr[26]
	wave4=DescTex_arr[27]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE26_l)=(0,0,0),rgb(PhEl_TUBE27_l)=(1,16019,65535),rgb(PhEl_TUBE28_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #7 Signals\r\\s(PhEl_TUBE25_l) "+wave1+"\r\\s(PhEl_TUBE26_l) "+wave2
	AppendText "\\s(PhEl_TUBE27_l) "+wave3+"\r\\s(PhEl_TUBE28_l) "+wave4
	RenameWindow #,G6
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.2,0.667,0.5,0.834)/FG=(FL,,,)/HOST=#   PhEl_TUBE29_l vs timebase_l
	AppendToGraph PhEl_TUBE30_l vs timebase_l
	AppendToGraph PhEl_TUBE31_l vs timebase_l
	AppendToGraph PhEl_TUBE32_l vs timebase_l
	wave1=DescTex_arr[28]
	wave2=DescTex_arr[29]
	wave3=DescTex_arr[30]
	wave4=DescTex_arr[31]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE30_l)=(0,0,0),rgb(PhEl_TUBE31_l)=(1,16019,65535),rgb(PhEl_TUBE32_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #8 Signals\r\\s(PhEl_TUBE29_l) "+wave1+"\r\\s(PhEl_TUBE30_l) "+wave2
	AppendText "\\s(PhEl_TUBE31_l) "+wave3+"\r\\s(PhEl_TUBE32_l) "+wave4
	RenameWindow #,G7
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.2,0.834,0.5,1)/FG=(FL,,,)/HOST=#   PhEl_TUBE33_l vs timebase_l
	AppendToGraph PhEl_TUBE34_l vs timebase_l
	AppendToGraph PhEl_TUBE35_l vs timebase_l
	AppendToGraph PhEl_TUBE36_l vs timebase_l
	wave1=DescTex_arr[32]
	wave2=DescTex_arr[33]
	wave3=DescTex_arr[34]
	wave4=DescTex_arr[35]
	ModifyGraph margin(left)=30,margin(bottom)=35,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE34_l)=(0,0,0),rgb(PhEl_TUBE35_l)=(1,16019,65535),rgb(PhEl_TUBE36_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize=12,fStyle=1,standoff=0
	ModifyGraph minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,0.5
	SetAxis bottom -0.2,8
	Label bottom "Time [sec]"
	TextBox/C/N=text0/A=MC/X=34/Y=19"\\F'Arial Unicode MS'\\Z12\\f01Chord #9 Signals\r\\s(PhEl_TUBE33_l) "+wave1+"\r\\s(PhEl_TUBE34_l) "+wave2
	AppendText "\\s(PhEl_TUBE35_l) "+wave3+"\r\\s(PhEl_TUBE36_l) "+wave4
	RenameWindow #,G8
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0.5,1,0.667)/HOST=#   PhEl_TUBE40_l vs timebase_l
	AppendToGraph PhEl_TUBE39_l vs timebase_l
	AppendToGraph PhEl_TUBE38_l vs timebase_l
	AppendToGraph PhEl_TUBE37_l vs timebase_l
	wave1=DescTex_arr[36]
	wave2=DescTex_arr[37]
	wave3=DescTex_arr[38]
	wave4=DescTex_arr[39]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE39_l)=(0,0,0),rgb(PhEl_TUBE38_l)=(1,16019,65535),rgb(PhEl_TUBE37_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,0.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #10 Signals\r\\s(PhEl_TUBE40_l) "+wave4+"\r\\s(PhEl_TUBE39_l) "+wave3
	AppendText "\\s(PhEl_TUBE38_l) "+wave2+"\r\\s(PhEl_TUBE37_l) "+wave1
	RenameWindow #,G9
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0.667,1,0.834)/HOST=#   PhEl_TUBE44_l vs timebase_l
	AppendToGraph PhEl_TUBE43_l vs timebase_l
	AppendToGraph PhEl_TUBE42_l vs timebase_l
	AppendToGraph PhEl_TUBE41_l vs timebase_l
	wave1=DescTex_arr[40]
	wave2=DescTex_arr[41]
	wave3=DescTex_arr[42]
	wave4=DescTex_arr[43]
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE43_l)=(0,0,0),rgb(PhEl_TUBE42_l)=(1,16019,65535),rgb(PhEl_TUBE41_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize(left)=12,fStyle=1,standoff=0
	ModifyGraph noLabel(bottom)=2,minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,0.5
	SetAxis bottom -0.2,8
	TextBox/C/N=text0/A=MC/X=34/Y=23"\\F'Arial Unicode MS'\\Z12\\f01Chord #11 Signals\r\\s(PhEl_TUBE44_l) "+wave4+"\r\\s(PhEl_TUBE43_l) "+wave3
	AppendText "\\s(PhEl_TUBE42_l) "+wave2+"\r\\s(PhEl_TUBE41_l) "+wave1
	RenameWindow #,G10
	SetActiveSubwindow ##
	
	PauseUpdate; Silent 1
	Display /W=(0.5,0.834,1,1)/HOST=#   PhEl_TUBE48_l vs timebase_l
	AppendToGraph PhEl_TUBE47_l vs timebase_l
	AppendToGraph PhEl_TUBE46_l vs timebase_l
	AppendToGraph PhEl_TUBE45_l vs timebase_l
	wave1=DescTex_arr[44]
	wave2=DescTex_arr[45]
	wave3=DescTex_arr[46]
	wave4=DescTex_arr[47]
	ModifyGraph margin(left)=30,margin(bottom)=35,margin(top)=5,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph rgb(PhEl_TUBE47_l)=(0,0,0),rgb(PhEl_TUBE46_l)=(1,16019,65535),rgb(PhEl_TUBE45_l)=(3,52428,1)
	ModifyGraph tick=2,mirror=1,font="Arial Unicode MS"
	ModifyGraph fSize=12,fStyle=1,standoff=0
	ModifyGraph minor=1,sep(bottom)=40,sep(left)=10,axisOnTop=1
	Label left "\\Z09Gain Corrected Voltage [V/V]"
	SetAxis left 0.0,0.5
	SetAxis bottom -0.2,8
	Label bottom "Time [sec]"
	TextBox/C/N=text0/A=MC/X=34/Y=19"\\F'Arial Unicode MS'\\Z12\\f01Chord #12 Signals\r\\s(PhEl_TUBE48_l) "+wave4+"\r\\s(PhEl_TUBE47_l) "+wave3
	AppendText "\\s(PhEl_TUBE46_l) "+wave2+"\r\\s(PhEl_TUBE45_l) "+wave1
	RenameWindow #,G11
	SetActiveSubwindow ##
	
	if(ratioYN ==1)
		
		// Chord #1
		Duplicate/O PhEL_TUBE01_L heli_0301_ne,heli_0102_te
		heli_0301_ne = PhEL_TUBE03_L/PhEL_TUBE01_L
		heli_0102_te = PhEL_TUBE01_L/PhEL_TUBE02_L
		
		// Chord #2
		Duplicate/O PhEL_TUBE05_L heli_0705_ne,heli_0506_te
		heli_0705_ne = PhEL_TUBE07_L/PhEL_TUBE05_L
		heli_0506_te = PhEL_TUBE05_L/PhEL_TUBE06_L
		
		// Chord #3
		Duplicate/O PhEL_TUBE09_L heli_1109_ne,heli_0910_te
		heli_1109_ne = PhEL_TUBE11_L/PhEL_TUBE09_L
		heli_0910_te = PhEL_TUBE09_L/PhEL_TUBE10_L
		
		// Chord #4
		Duplicate/O PhEL_TUBE16_L heli_1416_ne,heli_1615_te
		heli_1416_ne = PhEL_TUBE14_L/PhEL_TUBE16_L
		heli_1615_te = PhEL_TUBE16_L/PhEL_TUBE15_L
		
		// Chord #5
		Duplicate/O PhEL_TUBE20_L heli_1820_ne,heli_2019_te
		heli_1820_ne = PhEL_TUBE18_L/PhEL_TUBE20_L
		heli_2019_te = PhEL_TUBE20_L/PhEL_TUBE19_L
		
		// Chord #6
		Duplicate/O PhEL_TUBE24_L heli_2224_ne,heli_2423_te
		heli_2224_ne = PhEL_TUBE22_L/PhEL_TUBE24_L
		heli_2423_te = PhEL_TUBE24_L/PhEL_TUBE23_L
		
		// Chord #7
		Duplicate/O PhEL_TUBE25_L heli_2725_ne,heli_2526_te
		heli_2725_ne = PhEL_TUBE27_L/PhEL_TUBE25_L
		heli_2526_te = PhEL_TUBE25_L/PhEL_TUBE26_L
		
		// Chord #8
		Duplicate/O PhEL_TUBE29_L heli_3129_ne,heli_2930_te
		heli_3129_ne = PhEL_TUBE31_L/PhEL_TUBE29_L
		heli_2930_te = PhEL_TUBE29_L/PhEL_TUBE30_L
		
		// Chord #9
		Duplicate/O PhEL_TUBE33_L heli_3533_ne,heli_3334_te
		heli_3533_ne = PhEL_TUBE35_L/PhEL_TUBE33_L
		heli_3334_te = PhEL_TUBE33_L/PhEL_TUBE34_L
		
		// Chord #10
		Duplicate/O PhEL_TUBE40_L heli_3840_ne,heli_4039_te
		heli_3840_ne = PhEL_TUBE38_L/PhEL_TUBE40_L
		heli_4039_te = PhEL_TUBE40_L/PhEL_TUBE39_L
		
		// Chord #11
		Duplicate/O PhEL_TUBE44_L heli_4244_ne,heli_4443_te
		heli_4244_ne = PhEL_TUBE42_L/PhEL_TUBE44_L
		heli_4443_te = PhEL_TUBE44_L/PhEL_TUBE43_L
		
		// Chord #12
		Duplicate/O PhEL_TUBE48_L heli_4648_ne,heli_4847_te
		heli_4648_ne = PhEL_TUBE46_L/PhEL_TUBE48_L
		heli_4847_te = PhEL_TUBE48_L/PhEL_TUBE47_L
	endif
	SetDataFolder root:
	Print "Finished Loading Shot: "+num2istr(shot)
End
	
	