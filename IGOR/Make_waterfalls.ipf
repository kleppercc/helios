#pragma rtGlobals=1		// Use modern global access method.

Function HELIOS_Waterfall(shot,newPlot)
	Variable shot
	Variable newPlot
	
	Wave heli_0301_ne,heli_0102_te,heli_0705_ne,heli_0506_te
	Wave heli_1109_ne,heli_0910_te,heli_1416_ne,heli_1615_te
	Wave heli_1820_ne,heli_2019_te,heli_2224_ne,heli_2423_te
	Wave heli_2725_ne,heli_2526_te,heli_3129_ne,heli_2930_te
	Wave heli_3533_ne,heli_3334_te,heli_3840_ne,heli_4039_te
	Wave heli_4244_ne,heli_4443_te,heli_4648_ne,heli_4847_te
	
	Variable points=numpnts(heli_0301_ne)
	Variable i,testpnt

	wave phel_tube02_l,phel_tube06_l,phel_tube10_l
	wave phel_tube15_l,phel_tube19_l,phel_tube23_l
	wave phel_tube26_l,phel_tube30_l,phel_tube34_l
	wave phel_tube39_l,phel_tube43_l,phel_tube47_l
	
	make/o/n=(points,12) he7065_waterfall, te_waterfall
	he7065_waterfall[][0]=phel_tube02_l[p]
	he7065_waterfall[][1]=phel_tube06_l[p]
	he7065_waterfall[][2]=phel_tube10_l[p]
	he7065_waterfall[][3]=phel_tube15_l[p]
	he7065_waterfall[][4]=phel_tube19_l[p]
	he7065_waterfall[][5]=phel_tube23_l[p]
	he7065_waterfall[][6]=phel_tube26_l[p]
	he7065_waterfall[][7]=phel_tube30_l[p]
	he7065_waterfall[][8]=phel_tube34_l[p]
	he7065_waterfall[][9]=phel_tube39_l[p]
	he7065_waterfall[][10]=phel_tube43_l[p]
	he7065_waterfall[][11]=phel_tube47_l[p]
	
	te_waterfall[][0]=heli_0102_te[p]
	te_waterfall[][1]=heli_0506_te[p]
	te_waterfall[][2]=heli_0910_te[p]
	te_waterfall[][3]=heli_1615_te[p]
	te_waterfall[][4]=heli_2019_te[p]
	te_waterfall[][5]=heli_2423_te[p]
	te_waterfall[][6]=heli_2526_te[p]
	te_waterfall[][7]=heli_2930_te[p]
	te_waterfall[][8]=heli_3334_te[p]
	te_waterfall[][9]=heli_4039_te[p]
	te_waterfall[][10]=heli_4443_te[p]
	te_waterfall[][11]=heli_4847_te[p]
	
	If(newplot ==1)
		NewWaterfall ne_waterfall vs {Timebase_L,*}
		ModifyWaterfall angle=30, axlen= 0.5, hidden= 0
		ModifyGraph margin(left)=40,margin(bottom)=35,margin(top)=5,margin(right)=20
		ModifyGraph gaps=0,negRGB=(0,0,65535),tick=2,font="Arial Unicode MS"
		ModifyGraph fSize(left)=12,fSize(bottom)=12,fSize(right)=10,axisOnTop(bottom)=1
		ModifyGraph fStyle=1,lblMargin(right)=100,standoff=0,lblRot(right)=133
		ModifyGraph manTick(right)={1,1,0,0},manMinor(right)={0,0}
		Label bottom "Times [sec]"
		Label right "\\Z14\\F'Arial Unicode MS'Distance from Limiter [cm]"
		SetAxis left -1,400
		SetAxis bottom 8,-0.2
		SetAxis right 0,11
		
		NewWaterfall te_waterfall vs {Timebase_L,*}
	endif
End