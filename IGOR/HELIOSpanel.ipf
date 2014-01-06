#pragma rtGlobals=1		// Use modern global access method.
#include <FITS Loader>
#include <Resize Controls>
#include <WindowBrowser>

Window HELIOSPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(77,44,657,480)
	ModifyPanel cbRGB=(19675,39321,1), frameStyle=4, frameInset=1
	GroupBox mdspBOX,pos={22,123},size={175,120},title="\\JC  1. MDS+ Retrieve"
	GroupBox mdspBOX,labelBack=(48059,48059,48059),font="Helvetica Neue",fSize=13
	GroupBox mdspBOX,fStyle=1
	GroupBox hdf5BOX,pos={220,106},size={350,87},title="                              2. Load HDF5"
	GroupBox hdf5BOX,labelBack=(48059,48059,48059),font="Helvetica Neue",fSize=13
	GroupBox hdf5BOX,fStyle=1
	GroupBox postpBOX,pos={220,197},size={350,90},title="\\JC                       3. Wave Post-Process"
	GroupBox postpBOX,labelBack=(48059,48059,48059),font="Helvetica Neue",fSize=13
	GroupBox postpBOX,fStyle=1
	GroupBox ratioBOX,pos={27,254},size={183,111},title="\\JC  4. Make Ratios"
	GroupBox ratioBOX,labelBack=(48059,48059,48059),font="Helvetica Neue",fSize=13
	GroupBox ratioBOX,fStyle=1
	GroupBox crmBOX,pos={228,305},size={337,94},title="\\JC                       5. TEXTOR CRM"
	GroupBox crmBOX,labelBack=(48059,48059,48059),font="Helvetica Neue",fSize=13
	GroupBox crmBOX,fStyle=1
	SetVariable setSHOT,pos={196,72},size={175,28},title="SHOT #:",font="Gill Sans"
	SetVariable setSHOT,fSize=22,limits={-inf,inf,0},value= shot
	SetVariable setChanNum,pos={30,145},size={160,18},title="How Many Tubes (1 - 48):"
	SetVariable setChanNum,font="Gill Sans",fSize=13,limits={1,49,0},value= channum
	SetVariable setvar0,pos={235,128},size={325,29},title="HDF5 \rFile path:"
	SetVariable setvar0,font="Gill Sans",fSize=11,limits={0,inf,0},value= path
	SetVariable setvar1,pos={226,218},size={135,16},title="Downsample Factor:"
	SetVariable setvar1,font="Gill Sans",fSize=11,limits={0,inf,0},value= baseNum
	SetVariable setvar2,pos={376,217},size={120,16},title="# Smooth Pnts:"
	SetVariable setvar2,font="Gill Sans",fSize=11,limits={0,inf,0},value= pntsm
	SetVariable setvar3,pos={235,240},size={80,16},title="# Pre-Avg:"
	SetVariable setvar3,font="Gill Sans",fSize=11,limits={0,inf,0},value= interppnt
	SetVariable setvar4,pos={46,277},size={60,16},title="Setup #:",font="Gill Sans"
	SetVariable setvar4,fSize=11,limits={0,inf,0},value= setupNum
	SetVariable setvar5,pos={376,247},size={120,16},title="Perc. Sm. Level:"
	SetVariable setvar5,font="Gill Sans",fSize=11,limits={0,inf,0},value= frac
	CheckBox check0,pos={34,170},size={147,14},title="Print Unix Cmd in History"
	CheckBox check0,font="Gill Sans",fSize=12,variable= printunix
	CheckBox check0_1,pos={34,188},size={132,14},title="Print Results in History"
	CheckBox check0_1,font="Gill Sans",fSize=12,variable= printresult
	CheckBox check0_2,pos={236,262},size={75,14},title="Plot Waves?"
	CheckBox check0_2,font="Gill Sans",fSize=12,variable= plotit
	CheckBox check0_3,pos={38,297},size={75,14},title="Plot Waves?",font="Gill Sans"
	CheckBox check0_3,fSize=12,variable= plotit2
	Button button0_3,pos={67,27},size={60,60},proc=ClearGraphs,title="\\JCClear \r\\JC All \r Graphs \\JC"
	Button button0_3,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	Button button0,pos={45,212},size={120,20},proc=ButtonProc,title="Get From MDS+"
	Button button0,font="Gill Sans",fColor=(0,43690,65535)
	Button button0_1,pos={328,166},size={120,20},proc=ButtonProc_1,title="Load HDF5 File"
	Button button0_1,font="Gill Sans",fStyle=0,fColor=(0,43690,65535)
	Button button0_2,pos={503,235},size={60,30},proc=ButtonProc_2,title="Go"
	Button button0_2,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	Button button0_4,pos={503,235},size={60,30},proc=ButtonProc_2,title="Go"
	Button button0_4,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	Button button0_5,pos={126,280},size={60,30},proc=ButtonProc_4,title="Go"
	Button button0_5,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	TitleBox mainTITLE,pos={186,16},size={194,47},title="HELIOS LOADER PANEL \r\\Z12 (TEXTOR version)\\JC"
	TitleBox mainTITLE,labelBack=(48059,48059,48059)
	TitleBox mainTITLE,font="Helvetica Neue Bold Condensed",fSize=20,frame=2
	TitleBox mainTITLE,fStyle=0,anchor= MC
	TitleBox title0,pos={380,233},size={113,11},title="Set to <= wavpnts if not SHE"
	TitleBox title0,fSize=8,frame=0
	TitleBox title1,pos={380,233},size={113,11},title="Set to <= wavpnts if not SHE"
	TitleBox title1,fSize=8,frame=0
	TitleBox title2,pos={377,266},size={121,11},title="Equal 0.1 if not SHE; else = 0.5"
	TitleBox title2,fSize=8,frame=0
	CheckBox check0_4,pos={452,372},size={65,14},title="Plot Truc?",font="Gill Sans"
	CheckBox check0_4,fSize=12,variable= plotit2
	Button button0_6,pos={126,280},size={60,30},proc=ButtonProc_4,title="Go"
	Button button0_6,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	Button button0_7,pos={128,327},size={70,30},proc=ButtonProc_5,title="Plot Truc"
	Button button0_7,font="Gill Sans",fStyle=1,fColor=(0,43690,65535)
	SetVariable setvar6,pos={347,328},size={80,16},title="ne Min:",font="Gill Sans"
	SetVariable setvar6,fSize=11,limits={0,inf,0},value= nemin
	SetVariable setvar7,pos={347,347},size={80,16},title="ne Max:",font="Gill Sans"
	SetVariable setvar7,fSize=11,limits={0,inf,0},value= nemax
	SetVariable setvar8,pos={454,328},size={80,16},title="Te Min:",font="Gill Sans"
	SetVariable setvar8,fSize=11,limits={4,10,0},value= temin
	SetVariable setvar9,pos={454,347},size={80,16},title="Te Max:",font="Gill Sans"
	SetVariable setvar9,fSize=11,limits={0,inf,0},value= temax
	TitleBox title3,pos={32,326},size={92,32},title="\\JCTruncate waves\r to SHE puff?\\JC"
	TitleBox title3,fSize=12,frame=0,fStyle=1
EndMacro

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR printunix,printresult,channum,shot
			Variable makeraw = 0
			Variable maketbase = 1
			ExecutePythonShellCommand(printunix,printresult,makeraw,maketbase,channum,shot)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shot
			SVAR path
			load_Shot(shot,path)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shot,baseNum,pntsm,interppnt,plotit,channum,frac,npnts,tottime
			Make_wavs(channum,baseNum,pntsm,interppnt,shot,frac)
			Print "Now loading smoothed Sigs. for shot: "+num2istr(shot)
			Printf "With integration time of: %0.1e sec or sampling rate: %dHz\r",baseNum*(tottime/npnts),npnts/baseNum/tottime
			if (plotit)
				Execute "MakePlot()"
			endif
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ClearGraphs(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "CloseAllGraphs()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_4(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shot,plotit2
			Wave CHORDsetups
			Execute "MakeRatio(CHORDsetups,setupNum,shot)"
			if (plotit2)
				Execute "MakeRplot()"
			endif
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_5(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "RatioTRUC()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Window plot_he668_wf() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(370,44,802,357)
	AppendImage he6678_WF vs {tbase_plot,chdlocs_plot}
	ModifyImage he6678_WF ctab= {1e+15,1e+18,Geo,0}
	ModifyImage he6678_WF log= 1
	ModifyGraph margin(left)=30,margin(bottom)=30,margin(top)=10,margin(right)=50
	ModifyGraph tick=2
	ModifyGraph zero(left)=12
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=14,fSize(bottom)=12
	ModifyGraph standoff=0
	ModifyGraph axRGB(left)=(34952,34952,34952)
	ModifyGraph zeroThick(left)=2
	SetAxis bottom 0,6.5
EndMacro

Window plot_he7065_wf() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(387,328,769,661)
	AppendImage he7065_WF vs {tbase_plot,chdlocs_plot}
	ModifyImage he7065_WF ctab= {1e+15,1e+18,Geo,0}
	ModifyImage he7065_WF log= 1
	ModifyGraph margin(left)=30,margin(bottom)=30,margin(top)=10,margin(right)=50
	ModifyGraph tick=2
	ModifyGraph zero(left)=12
	ModifyGraph mirror(left)=1,mirror(bottom)=2
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=14,fSize(bottom)=12
	ModifyGraph standoff=0
	ModifyGraph axRGB(left)=(34952,34952,34952)
	ModifyGraph zeroThick(left)=2
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	SetAxis bottom 0,6.5
	ColorScale/C/N=text0/F=0/A=MC/X=58.94/Y=1.37 image=he7065_WF, heightPct=100
	ColorScale/C/N=text0 tickLen=2, font="Helvetica Neue Bold Condensed", fsize=14
	ColorScale/C/N=text0 log=1
EndMacro

Window plot_he7281_wf() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(475,303,855,637)
	AppendImage he7281_WF vs {tbase_plot,chdlocs_plot}
	ModifyImage he7281_WF ctab= {1e+15,1e+18,Geo,0}
	ModifyImage he7281_WF log= 1
	ModifyGraph margin(left)=30,margin(bottom)=30,margin(top)=10,margin(right)=50
	ModifyGraph tick=2
	ModifyGraph zero(left)=12
	ModifyGraph mirror(left)=1,mirror(bottom)=2
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=14
	ModifyGraph standoff=0
	ModifyGraph axRGB(left)=(34952,34952,34952)
	ModifyGraph zeroThick(left)=2
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={1,0}
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	Label bottom "time [sec]"
	SetAxis bottom 0,6.5
EndMacro
