import h5py as h5p
from os import chdir
import sys
import MDSplus as mds

## Variable definitions
tubenum = 48
makeNode = int(sys.argv[1])
thtck = int(sys.argv[2])
SHOT = int(sys.argv[3])

chdir('/Users/unterbee/helios/Python')

#Load in the calibration files
file=h5p.File('CALNums.h5')
CAL_PMT=file['CAL_PMT'].value
CAL_BG=file['CAL_BG'].value
CAL_CTRL=file['CAL_CTRL'].value
file.close()

###---For thin connections
if thtck == 0:
    #MDScon = mds.Connection('localhost')
    MDScon = mds.Connection('134.94.245.16')
    MDScon.openTree('helios',SHOT)

###---For thick connections
if thtck == 1:
    TreeObj = mds.Tree('helios',SHOT)

for j in range(1,tubenum+1):
    if j < 10:
        PMTstr='TUBE0'+str(j)
        CTRLstr='TUBE0'+str(j)
    else:
        PMTstr='TUBE'+str(j)
        CTRLstr='TUBE'+str(j)

    if makeNode == 1:
        if thtck == 1:
        	TreeObj.addNode('.'+PMTstr+':CAL_PMT','NUMERIC')
        	TreeObj.addNode('.'+PMTstr+':CAL_CTRL','NUMERIC')
        	TreeObj.write()
        if thtck ==0:
        	MDScon.addNode('.'+PMTstr+':CAL_PMT','NUMERIC')
        	MDScon.addNode('.'+PMTstr+':CAL_CTRL','NUMERIC')

	if thtck ==1:
		PMTNode = TreeObj.getNode(':'+PMTstr).getNode('CAL_PMT')
		CTRLNode = TreeObj.getNode(':'+CTRLstr).getNode('CAL_CTRL')

    putdat0 = mds.Float32(round(CAL_PMT[j-1] - CAL_BG[j-1],3))
    putdat1 = mds.Float32(round(CAL_CTRL[j-1],3))

    if thtck ==1:
    	PMTNode.putData(putdat0)
    	CTRLNode.putData(putdat1)
    if thtck ==0:
    	theNODE1 = PMTstr+":CAL_PMT"
    	MDScon.put(theNODE1,"$",putdat0)
    	theNODE2 = PMTstr+":CAL_CTRL"
    	MDScon.put(theNODE1,"$",putdat1)