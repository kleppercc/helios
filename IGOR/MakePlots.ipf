#pragma rtGlobals=1		// Use modern global access method.

Macro MakePlot()	
	CHORD1()
	CHORD2()
	CHORD3()
	CHORD4()
	CHORD5()
	CHORD6()
	CHORD7()
	CHORD8()
	CHORD9()
	CHORD10()
	CHORD11()
	CHORD12()
End

Window CHORD1() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[0]+"_L_fin"
	String nam2=RefNamwav[1]+"_L_fin"
	String nam3=RefNamwav[2]+"_L_fin"
	String nam4=RefNamwav[3]+"_L_fin"
	Display /W=(35,44,478,306) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0),tick=2,zero(left)=1,mirror=1
	ModifyGraph font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0,notation(left)=1,log(left)=1
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[0][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
	TextBox/C/N=text1/A=MC/F=0/X=-30/Y=39 "\\F'Helvetica Neue Bold Condensed'\\Z12SHOT: "+num2istr(shot)
EndMacro

Window CHORD2() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[4]+"_L_fin"
	String nam2=RefNamwav[5]+"_L_fin"
	String nam3=RefNamwav[6]+"_L_fin"
	String nam4=RefNamwav[7]+"_L_fin"
	Display /W=(35,329,478,592) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[1][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD3() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[8]+"_L_fin"
	String nam2=RefNamwav[9]+"_L_fin"
	String nam3=RefNamwav[10]+"_L_fin"
	String nam4=RefNamwav[11]+"_L_fin"
	Display /W=(35,614,478,877) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[2][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD4() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[12]+"_L_fin"
	String nam2=RefNamwav[13]+"_L_fin"
	String nam3=RefNamwav[14]+"_L_fin"
	String nam4=RefNamwav[15]+"_L_fin"
	Display /W=(483,44,926,306) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[3][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
	TextBox/C/N=text1/A=MC/F=0/X=-30/Y=39 "\\F'Helvetica Neue Bold Condensed'\\Z12SHOT: "+num2istr(shot)
EndMacro

Window CHORD5() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[16]+"_L_fin"
	String nam2=RefNamwav[17]+"_L_fin"
	String nam3=RefNamwav[18]+"_L_fin"
	String nam4=RefNamwav[19]+"_L_fin"
	Display /W=(483,328,926,590) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[4][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD6() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[20]+"_L_fin"
	String nam2=RefNamwav[21]+"_L_fin"
	String nam3=RefNamwav[22]+"_L_fin"
	String nam4=RefNamwav[23]+"_L_fin"
	Display /W=(483,614,926,876) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[5][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD7() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[24]+"_L_fin"
	String nam2=RefNamwav[25]+"_L_fin"
	String nam3=RefNamwav[26]+"_L_fin"
	String nam4=RefNamwav[27]+"_L_fin"
	Display /W=(927,44,1370,306) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[6][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
	TextBox/C/N=text1/A=MC/F=0/X=-30/Y=39 "\\F'Helvetica Neue Bold Condensed'\\Z12SHOT: "+num2istr(shot)
EndMacro

Window CHORD8() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[28]+"_L_fin"
	String nam2=RefNamwav[29]+"_L_fin"
	String nam3=RefNamwav[30]+"_L_fin"
	String nam4=RefNamwav[31]+"_L_fin"
	Display /W=(928,328,1371,590) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[7][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD9() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[32]+"_L_fin"
	String nam2=RefNamwav[33]+"_L_fin"
	String nam3=RefNamwav[34]+"_L_fin"
	String nam4=RefNamwav[35]+"_L_fin"
	Display /W=(927,613,1370,875) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam1)=(3,52428,1),rgb($nam2)=(0,0,65535),rgb($nam3)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[8][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD10() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[36]+"_L_fin"
	String nam2=RefNamwav[37]+"_L_fin"
	String nam3=RefNamwav[38]+"_L_fin"
	String nam4=RefNamwav[39]+"_L_fin"
	Display /W=(1371,44,1814,306)$nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30"\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[9][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
	TextBox/C/N=text1/A=MC/F=0/X=-30/Y=39 "\\F'Helvetica Neue Bold Condensed'\\Z12SHOT: "+num2istr(shot)
EndMacro

Window CHORD11() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[40]+"_L_fin"
	String nam2=RefNamwav[41]+"_L_fin"
	String nam3=RefNamwav[42]+"_L_fin"
	String nam4=RefNamwav[43]+"_L_fin"
	Display /W=(1371,328,1814,590) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30 "\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[10][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro

Window CHORD12() : Graph
	PauseUpdate; Silent 1		// building window...
	String nam1=RefNamwav[44]+"_L_fin"
	String nam2=RefNamwav[45]+"_L_fin"
	String nam3=RefNamwav[46]+"_L_fin"
	String nam4=RefNamwav[47]+"_L_fin"
	Display /W=(1373,613,1816,875) $nam1,$nam2,$nam3,$nam4 vs tBase_L
	ModifyGraph rgb($nam4)=(3,52428,1),rgb($nam3)=(0,0,65535),rgb($nam2)=(0,0,0)
	ModifyGraph tick=2,zero(left)=1,mirror=1,font="Helvetica Neue Bold Condensed",fSize=12,fStyle=1,lblMargin(bottom)=10,standoff=0 
	ModifyGraph axisOnTop(bottom)=1,manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0},notation(left)=1,log(left)=1,axisOnTop=1
	Label bottom "Time [sec]"
	SetAxis left 1e+12,1e+16
	Legend/C/N=text0/J/A=MC/X=0/Y=-30"\\F'Helvetica Neue Bold Condensed'CHORD "+num2istr(CHORDsetups[11][setupNum])+"\r\\s("+nam1+") "+nam1[0,8]+"\r\\s("+nam2+") "+nam2[0,8]+""
	AppendText "\\s("+nam3+") "+nam3[0,8]+"\r\\s("+nam4+") "+nam4[0,8]
EndMacro