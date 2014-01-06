import h5py as h5p
from os import chdir
import sys
import MDSplus as mds
import numpy as np

## Variable definitions
tubeNum = 48
SHOT = int(sys.argv[1])

chdir('/Users/unterbee/Desktop')

#Load in the calibration files
file=h5p.File('TEXTOR_data/s'+str(SHOT)+'.h5')
ADGAIN=file['AD_Gain'].value
DELAY = file['t_Delay'].value
FREQ=file['DEL_t'].value
NUM_SAMPLES=file['NumPnts'].value
TRIGGER = file['t_Trigger'].value

GAIN_arr = file['OpAmpGain_Arr'].value
PMTdesc_arr = file['DescTex_Arr'].value
PMTarr = np.ones((NUM_SAMPLES,tubeNum))
CTRLarr = np.ones((NUM_SAMPLES,tubeNum))
for j in range(0,tubeNum):
    if (j+1) < 10:
        PMTarr[:,j] = file['VOLT_TUBE0'+str(j+1)]
        CTRLarr[:,j] = file['CRTL_TUBE0'+str(j+1)]
    else:
        PMTarr[:,j] = file['VOLT_TUBE'+str(j+1)]
        CTRLarr[:,j] = file['CRTL_TUBE'+str(j+1)]
file.close()

mds.Connection('localhost')
TreeObj = mds.Tree('helios',SHOT)

adNode = TreeObj.getNode('ADGAIN')
adNode.putData(ADGAIN)
delayNode = TreeObj.getNode('DELAY')
delayNode.putData(DELAY)
freqNode = TreeObj.getNode('FREQ')
freqNode.putData(FREQ)
sampNode = TreeObj.getNode('NUM_SAMPLES')
sampNode.putData(NUM_SAMPLES)
trigNode = TreeObj.getNode('TRIGGER')
trigNode.putData(TRIGGER)

for j in range(1,tubeNum+1):
    if j < 10:
        PMTstr='TUBE0'+str(j)
    else:
        PMTstr='TUBE'+str(j)
    TubeNode = TreeObj.getNode(PMTstr)
    
    PMTNode = TubeNode.getNode('PMT_VOLT')
    putarr = PMTarr[:,j-1]
    PMTNode.putData(putarr)
    
    CTRLNode = TubeNode.getNode('PMT_CTRL')
    putarr1 = CTRLarr[:,j-1]
    CTRLNode.putData(putarr1)
    
    gainNode = TubeNode.getNode('GAIN')
    putdat = GAIN_arr[j-1]
    gainNode.putData(putdat)
    
    descNode = TubeNode.getNode('PMT_DESC')
    putstr = PMTdesc_arr[j-1]
    descNode.putData(putstr)

# add relative constant = 1.0 to tree.