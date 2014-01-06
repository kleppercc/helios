#pragma rtGlobals=1		// Use modern global access method.

Macro RatioTRUC()
	 R_CH214()
	 R_CH215()
	 R_CH216()
	 R_CH217()
	 R_CH218()
	 R_CH219()
	 R_CH220()
	 R_CH221()
	 R_CH222()
	 R_CH223()
	 R_CH224()
	 R_CH225()
EndMacro

Window R_CH214() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(1275,44,1705,319) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH214_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH214_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH214_R728706_TRUNC)=3,mode(CH214_R668728_TRUNC)=3
	ModifyGraph marker(CH214_R728706_TRUNC)=16,marker(CH214_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH214_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH214_R728706_TRUNC)=4,msize(CH214_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH214_R728706_TRUNC)=1,useMrkStrokeRGB(CH214_R668728_TRUNC)=1
	ModifyGraph offset(CH214_R728706_TRUNC)={-0.039,0},offset(CH214_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,4}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2.5
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH215() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(1281,334,1709,600) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH215_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH215_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH215_R728706_TRUNC)=3,mode(CH215_R668728_TRUNC)=3
	ModifyGraph marker(CH215_R728706_TRUNC)=16,marker(CH215_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH215_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH215_R728706_TRUNC)=4,msize(CH215_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH215_R728706_TRUNC)=1,useMrkStrokeRGB(CH215_R668728_TRUNC)=1
	ModifyGraph offset(CH215_R728706_TRUNC)={-0.039,0},offset(CH215_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5},muloffset(CH215_R728706_TRUNC)={0,0.4},muloffset(CH215_R668728_TRUNC)={0,2.5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH216() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(1287,627,1717,901) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH216_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH216_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH216_R728706_TRUNC)=3,mode(CH216_R668728_TRUNC)=3
	ModifyGraph marker(CH216_R728706_TRUNC)=16,marker(CH216_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(43690,43690,43690),rgb(CH216_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH216_R728706_TRUNC)=4,msize(CH216_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH216_R728706_TRUNC)=1,useMrkStrokeRGB(CH216_R668728_TRUNC)=1
	ModifyGraph offset(CH216_R728706_TRUNC)={-0.04,0},offset(CH216_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,3},muloffset(CH216_R728706_TRUNC)={0,3},muloffset(CH216_R668728_TRUNC)={0,0.75}
	ModifyGraph grid(left)=1,grid(right)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph gridRGB(left)=(65535,0,0),gridRGB(right)=(0,0,65535)
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0}
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706) T_e"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728) n_e"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH217() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(872,627,1299,893) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH217_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH217_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH217_R728706_TRUNC)=3,mode(CH217_R668728_TRUNC)=3
	ModifyGraph marker(CH217_R728706_TRUNC)=16,marker(CH217_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(43690,43690,43690),rgb(CH217_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH217_R728706_TRUNC)=4,msize(CH217_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH217_R728706_TRUNC)=1,useMrkStrokeRGB(CH217_R668728_TRUNC)=1
	ModifyGraph offset(CH217_R728706_TRUNC)={-0.039,0},offset(CH217_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,3}
	ModifyGraph grid(right)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph sep(right)=1
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph gridRGB(right)=(0,0,65535)
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,2}
	Label left "\\Z14R(728/706) T_e"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728) n_e"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH218() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(867,332,1294,599) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH218_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH218_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH218_R728706_TRUNC)=3,mode(CH218_R668728_TRUNC)=3
	ModifyGraph marker(CH218_R728706_TRUNC)=16,marker(CH218_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH218_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH218_R728706_TRUNC)=4,msize(CH218_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH218_R728706_TRUNC)=1,useMrkStrokeRGB(CH218_R668728_TRUNC)=1
	ModifyGraph offset(CH218_R728706_TRUNC)={-0.039,0},offset(CH218_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5},muloffset(CH218_R728706_TRUNC)={0,10},muloffset(CH218_R668728_TRUNC)={0,0.1}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH219() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(869,44,1297,313) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH219_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH219_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH219_R728706_TRUNC)=3,mode(CH219_R668728_TRUNC)=3
	ModifyGraph marker(CH219_R728706_TRUNC)=16,marker(CH219_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH219_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH219_R728706_TRUNC)=4,msize(CH219_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH219_R728706_TRUNC)=1,useMrkStrokeRGB(CH219_R668728_TRUNC)=1
	ModifyGraph offset(CH219_R728706_TRUNC)={-0.039,0},offset(CH219_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH220() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(444,44,874,314) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH220_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH220_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH220_R728706_TRUNC)=3,mode(CH220_R668728_TRUNC)=3
	ModifyGraph marker(CH220_R728706_TRUNC)=16,marker(CH220_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH220_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH220_R728706_TRUNC)=4,msize(CH220_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH220_R728706_TRUNC)=1,useMrkStrokeRGB(CH220_R668728_TRUNC)=1
	ModifyGraph offset(CH220_R728706_TRUNC)={-0.04,0},offset(CH220_R668728_TRUNC)={-0.04,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph grid(left)=1,grid(right)=1
	ModifyGraph tick=2
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph gridRGB(left)=(65535,0,0),gridRGB(right)=(0,0,65535)
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(bottom)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH221() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(443,338,871,607) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH221_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH221_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH221_R728706_TRUNC)=3,mode(CH221_R668728_TRUNC)=3
	ModifyGraph marker(CH221_R728706_TRUNC)=16,marker(CH221_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH221_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH221_R728706_TRUNC)=4,msize(CH221_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH221_R728706_TRUNC)=1,useMrkStrokeRGB(CH221_R668728_TRUNC)=1
	ModifyGraph offset(CH221_R728706_TRUNC)={-0.039,0},offset(CH221_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis right 0,15
EndMacro

Window R_CH222() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(445,628,873,897) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH222_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH222_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH222_R728706_TRUNC)=3,mode(CH222_R668728_TRUNC)=3
	ModifyGraph marker(CH222_R728706_TRUNC)=16,marker(CH222_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH222_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH222_R728706_TRUNC)=4,msize(CH222_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH222_R728706_TRUNC)=1,useMrkStrokeRGB(CH222_R668728_TRUNC)=1
	ModifyGraph offset(CH222_R728706_TRUNC)={-0.039,0},offset(CH222_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH223() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(18,628,446,897) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH223_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH223_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH223_R728706_TRUNC)=3,mode(CH223_R668728_TRUNC)=3
	ModifyGraph marker(CH223_R728706_TRUNC)=16,marker(CH223_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH223_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH223_R728706_TRUNC)=4,msize(CH223_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH223_R728706_TRUNC)=1,useMrkStrokeRGB(CH223_R668728_TRUNC)=1
	ModifyGraph offset(CH223_R728706_TRUNC)={-0.039,0},offset(CH223_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH224() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(15,335,445,606) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH224_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH224_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH224_R728706_TRUNC)=3,mode(CH224_R668728_TRUNC)=3
	ModifyGraph marker(CH224_R728706_TRUNC)=16,marker(CH224_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH224_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH224_R728706_TRUNC)=4,msize(CH224_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH224_R728706_TRUNC)=1,useMrkStrokeRGB(CH224_R668728_TRUNC)=1
	ModifyGraph offset(CH224_R728706_TRUNC)={-0.039,0},offset(CH224_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro

Window R_CH225() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(18,44,446,313) :s118794_wavs:y_she_corr vs :s118794_wavs:x_she1
	AppendToGraph CH225_R728706_TRUNC vs tBase_TRUNC
	AppendToGraph/R CH225_R668728_TRUNC vs tBase_TRUNC
	ModifyGraph margin(left)=35,margin(bottom)=30,margin(top)=10,margin(right)=35
	ModifyGraph mode(y_she_corr)=7,mode(CH225_R728706_TRUNC)=3,mode(CH225_R668728_TRUNC)=3
	ModifyGraph marker(CH225_R728706_TRUNC)=16,marker(CH225_R668728_TRUNC)=19
	ModifyGraph rgb(y_she_corr)=(26214,26214,26214),rgb(CH225_R668728_TRUNC)=(0,0,65535)
	ModifyGraph msize(CH225_R728706_TRUNC)=4,msize(CH225_R668728_TRUNC)=4
	ModifyGraph hbFill(y_she_corr)=5
	ModifyGraph useMrkStrokeRGB(CH225_R728706_TRUNC)=1,useMrkStrokeRGB(CH225_R668728_TRUNC)=1
	ModifyGraph offset(CH225_R728706_TRUNC)={-0.039,0},offset(CH225_R668728_TRUNC)={-0.039,0}
	ModifyGraph muloffset(y_she_corr)={0,5}
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph tlblRGB(left)=(65535,0,0),tlblRGB(right)=(0,0,65535)
	ModifyGraph alblRGB(left)=(65535,0,0),alblRGB(right)=(0,0,65535)
	ModifyGraph axisOnTop(left)=1,axisOnTop(right)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	ModifyGraph manTick(right)={0,5,0,0},manMinor(right)={1,0}
	Label left "\\Z14R(728/706)"
	Label bottom "\\Z14TIME  [sec]"
	Label right "\\Z14R(668/728)"
	SetAxis left 0,2
	SetAxis bottom 0,6.5
	SetAxis right 0,15
EndMacro
