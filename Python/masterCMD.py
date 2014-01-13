############################################
# This script runs the show for preping and processing the HELIOS CRM data
#
# Some usage notes:
#
# I find it easiest to control with an input dictionary.
# Here's an example:
#INdict = {'SHOT': 118800,
# 		 'pathNAM': '/Users/unterbee/Dropbox/HELIOS Master/20140111',
# 		 'fnamH5': '/s118800_wavs.h5',
# 		 'fnamMAT': '/shot_118800.mat',
# 		 'chanNum2view': 19,
# 		 'legTF': True,
# 		 'quiet':False,
		# }
#
# The script to preprocess the raw data is:
#rawDF,downsamDF,smDF,bacoffDF,truncDF,finDF,SHEdata=mast.runHELIOSprep(INdict['SHOT'],
#   INdict['pathNAM'],INdict['pathNAM']+INdict['fnamH5'],INdict['pathNAM']+INdict['fnamMAT'],quiet=INdict['quiet'])
#
# A script to plot up the processed data:
#mast.plot_HELOISprep_chan(rawDF,downsamDF,smDF,bacoffDF,truncDF,SHEdata,chanNum2view=INdict['chanNum2view'],legTF=INdict['legTF'])
# 
# 
# Author: E.A. Unterberg (unterberge@fusion.gat.com)
# Developed on: January 2014



import helios.Python.CRMprep as prep
import helios.Python.makRATIOS as mR
import helios.Python.getSHOT as gST
import pylab as plt

reload(prep)
reload(mR)
reload(gST)

def runHELIOSprep(SHOT,pathNAM,fnamH5,fnamMAT,CHDsetupNum=6,downSAMPfac=100,bacPNTSM=5,bacinterppnt=350,bacfrac=30,quiet=True):
	rawDF,header = prep.loadtoPDS(SHOT,quiet=False)
	downsamDF,smDF,bacoffDF = prep.makWavs(rawDF,header,baseNum=downSAMPfac,bacPNTSM=bacPNTSM,bacinterppnt=bacinterppnt,bacfrac=bacfrac,quiet=quiet)
	truncDF = prep.truncWavs(SHOT,bacoffDF,fnamH5,quiet=quiet)
	SHEdata = gST.load2DICT(fnamH5)
	finDF = mR.run(SHOT,truncDF,CHDsetNum=CHDsetupNum,CHDpath=pathNAM,quiet=quiet)
	return rawDF,downsamDF,smDF,bacoffDF,truncDF,finDF,SHEdata

def plot_discharge(SHOT,pathNAM,legeON):
	gST.plotITup(SHOT,path=pathNAM,legON=legeON)
	return 'Done: plot_discharge'

def plot_HELOISprep_chan(rawDF,downsamDF,smDF,bacoffDF,truncDF,SHEdata,chanNum2view,legTF):
	plt.figure();
	plt.plot(rawDF[chanNum2view].index,rawDF[chanNum2view].values,c='grey',label=rawDF[chanNum2view].name,alpha=0.5);
	plt.plot(downsamDF[chanNum2view].index,downsamDF[chanNum2view].values,c='k',marker='o',label=downsamDF[chanNum2view].name);
	smDF[chanNum2view].plot(legend=legTF,c='r',linewidth=2);
	bacoffDF[chanNum2view].plot(legend=legTF,c='g',linewidth=2);
	plt.plot(SHEdata['x_she_corr'],1e13*SHEdata['y_she_corr'],'b',label='SHE on');
	plt.plot(truncDF[chanNum2view].index,truncDF[chanNum2view].values,marker='o',label=truncDF[chanNum2view].name)
	plt.xlabel('time [s]')
	plt.title('check waves')
	if legTF:
		plt.legend();

def TEX_CRM(SHOT,nemin,nemax,temin,temax,finDF):
	rneDF,rteDF = parse_finDF(finDF)
	return

def parse_finDF(finDF):

	return Rne_DF,Rte_DF
# Function TEX_CRM(shot,nemin,nemax,temin,temax,rne_2d,rte_2d)

# 	Duplicate/o rne_2d ne_TEXTOR2d
# 	Duplicate/o rte_2d te_TeXTOR2d
	
# 	Variable pntCmd = 0
# 	Variable pntRlt = 0
	
# 	Variable rne
# 	Variable rte
# 	string CRMoutStr
# 	Make/O/N=2 neTeWav
	
# 	Variable k,l,m
# 	Variable endrow = dimsize(rne_2d,0)
# 	Variable endcol  = dimsize(rne_2d,1)
	
# 	m=0
# 	for(k=0;k<endrow;k +=1)
# 		for(l=0;l<endcol;l +=1)
# 			rne = rne_2d[k][l]
# 			rte = rte_2d[k][l]
# 			CRMoutStr= ExecutePythonShellCommand2(pntCmd, pntRlt,shot,nemin,nemax,temin,temax,rne,rte)
# 			neTeWav = parseFUNC(CRMoutStr)
# 			ne_TEXTOR2d[k][l] = neTeWav[0]
# 			te_TEXTOR2d[k][l] = neTeWav[1]
		
# 		endfor
# 		m +=1
# 		printf "Time: %0.1f\r",(m/176)*100
# 	endfor
# End

# Function/S ExecutePythonShellCommand2(printCommandInHistory, printResultInHistory,shot,nemin,nemax,temin,temax,rne,rte)
# 	Variable printCommandInHistory
# 	Variable printResultInHistory
# 	Variable shot
# 	Variable nemin
# 	Variable nemax
# 	Variable temin
# 	Variable temax
# 	Variable rne
# 	Variable rte

# 	String uCommand =". ${HOME}/.bash_profile; python Users/unterbee/helios/CRM_sources/TEXTOR/textorCRM.py" 
# 	uCommand = uCommand+" "+num2istr(shot)+" "+num2str(temin)+" "+num2str(temax)+" "+num2str(nemin)+" "+num2str(nemax)+" "+num2str(rne)+" "+num2str(rte)
	
# 	if (printCommandInHistory)
# 		printf "Unix command: %s\r", uCommand
# 	endif
	
# 	String cmd
# 	sprintf cmd, "do shell script \"%s\"", uCommand
# 	ExecuteScriptText cmd

# 	if (printResultInHistory)
# 		Print S_value
# 	endif

# 	return S_value
# End

# Function  parseFUNC(inSTR)
# 	string inSTR
	
# 	String out1,out2,out3,out4,out5
# 	make/n=2 numsout
# 	variable v1,v2
# 	sscanf inSTR, "%s %s %s %s %s %f %f",out1,out2,out3,out4,out5,v1,v2
	
# 	numsout[0] = v1
# 	numsout[1] = v2
# return numsout
