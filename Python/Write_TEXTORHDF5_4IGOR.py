import sys
from numpy import *
from scipy import *

import MDSplus
#----Use if using Tom's MDSplus module
#from pmds import *

#Needed for warning suppression at the moment
import warnings
warnings.simplefilter('ignore', DeprecationWarning)

write_HDF = int(sys.argv[1])
chanNum = int(sys.argv[2]) # from 2-49
shot = int(sys.argv[3])  #138767

##--------
#mdsconnect('134.94.245.16')
#mdsopen('HELIOS', shot)
##--------
shotNode = MDSplus.Tree('HELIOS',shot)

#==== Get common digitizer information ====
#-----
#Var0=':ADGAIN'
#ADGAIN = mdsvalue(Var0)
#-----
ADGAIN = float(shotNode.getNode('ADGAIN').getData()) 
print 'A/D RESOLUTION: %s [V/bit]' %ADGAIN

#----
#Var2 = ':FREQ'
#DIG_FREQ = mdsvalue(Var2)
#----
DIG_FREQ = float(shotNode.getNode('FREQ').getData())
print 'DEL_T:',DIG_FREQ

#----
#Var3 = ':NUM_SAMPLES'
#SAMPLES = mdsvalue(Var3)
#----
SAMPLES = int(shotNode.getNode('NUM_SAMPLES').getData())
print 'NUM_SAMPS:',SAMPLES

#------
#Var1=':DELAY'
#DELAY = mdsvalue(Var1)
#Var4 = ':TRIGGER'
#T_START = mdsvalue(Var4)
#----
DELAY = float(shotNode.getNode('DELAY').getData())
T_START = float(shotNode.getNode('TRIGGER').getData())
print 'DELAY, TRIG:', DELAY,T_START
#==========================================

#++++++++++++++++++++++++++++++++++++++++++
print "START: Data Grab"

fullNamSig=[]
fullSigDat=[]

fullNamCrtl=[]
fullCrtlDat=[]

fullNamGain=[]
fullGainVar=[]

fullSigDesc=[]
fullDescTex=[]

for i in range(1,chanNum):
    if i < 10:
        #sigNam=':TUBE0'+str(i)+':PMT_VOLT'   
        #crtlNam=':TUBE0'+str(i)+':PMT_CTRL'
        #gainNam=':TUBE0'+str(i)+':GAIN'
        #sigTex=':TUBE0'+str(i)+':PMT_DESC'
        sigNam='TUBE0'+str(i)+':PMT_VOLT'
        crtlNam='TUBE0'+str(i)+':PMT_CTRL'
        gainNam='TUBE0'+str(i)+':GAIN'
        sigTex='TUBE0'+str(i)+':PMT_DESC'
    else:
        #sigNam=':TUBE'+str(i)+':PMT_VOLT'
        #crtlNam=':TUBE'+str(i)+':PMT_CTRL'
        #gainNam=':TUBE'+str(i)+':GAIN'
        #sigTex=':TUBE'+str(i)+':PMT_DESC'
        sigNam='TUBE'+str(i)+':PMT_VOLT'
        crtlNam='TUBE'+str(i)+':PMT_CTRL'
        gainNam='TUBE'+str(i)+':GAIN'
        sigTex='TUBE'+str(i)+':PMT_DESC'
    
    fullNamSig.append(sigNam)
    fullNamCrtl.append(crtlNam)
    fullNamGain.append(gainNam)
    fullSigDesc.append(sigTex)
    
for i in range(1,chanNum):
    #gaindat = mdsvalue(fullNamGain[i-1])
    #fullGainVar.append(gaindat)
    #sigdat = mdsvalue(fullNamSig[i-1])
    #fullSigDat.append(sigdat)
    #crtldat = mdsvalue(fullNamCrtl[i-1])
    #fullCrtlDat.append(crtldat)
    #desctex = mdsvalue(fullSigDesc[i-1])
    #fullDescTex.append(desctex)
    
    gaindat = float(shotNode.getNode(fullNamGain[i-1]).getData())
    fullGainVar.append(gaindat)
    
    sigdat = array(shotNode.getNode(fullNamSig[i-1]).getData())
    fullSigDat.append(sigdat)
    
    crtldat = array(shotNode.getNode(fullNamCrtl[i-1]).getData())
    fullCrtlDat.append(crtldat)
    
    desctex = str(shotNode.getNode(fullSigDesc[i-1]).getData())
    fullDescTex.append(desctex)
    print '-- Chan.#',i

#----
#mdsclose('HELIOS',shot)
#mdsdisconnect

print 'STOP: Data Grab'
#++++++++++++++++++++++++++++++++++++++++++++++

#------------ Write HDF5 file -----------------
if write_HDF == 1:
    print 'START: Write HDF5'
    from h5py import *

    fstore = File('/Users/unterbee/Desktop/TEXTOR_HELIOS/TEXTOR_data_'+str(shot)+'.h5','w')

    # ---- Dig. Settings -----
    tagNam='AD_Gain'
    dimshape=shape(ADGAIN)
    ds = fstore.create_dataset(tagNam,dimshape,'f')
    ds[...] = ADGAIN
    tagNam='t_Delay'
    dimshape=shape(DELAY)
    ds = fstore.create_dataset(tagNam,dimshape,'f')
    ds[...] = DELAY
    tagNam='NumPnts'
    dimshape=shape(SAMPLES)
    ds = fstore.create_dataset(tagNam,dimshape,'f')
    ds[...] = SAMPLES
    tagNam='t_Trigger'
    dimshape=shape(T_START)
    ds = fstore.create_dataset(tagNam,dimshape,'f')
    ds[...] = T_START
    tagNam='DEL_t'
    dimshape=shape(DIG_FREQ)
    ds = fstore.create_dataset(tagNam,dimshape,'f')
    ds[...] = DIG_FREQ
    #--------------------------
    
    tagNam='OpAmpGain_Arr'
    dimshape=shape(fullGainVar)
    ds = fstore.create_dataset(tagNam,dimshape,'i',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = fullGainVar
    
    tagNam='DescTex_Arr'
    dimshape=shape(fullDescTex)
    dt = special_dtype(vlen=str)
    ds = fstore.create_dataset(tagNam,dimshape,dtype=dt,compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = fullDescTex
    
    #+++++++++++ 'Git the Data +++++++++++++++
    for i in range(1,chanNum):
        tagNam='VOLT_'+fullNamSig[i-1][0:6]
        dimshape=shape(fullSigDat[i-1])
        ds = fstore.create_dataset(tagNam,dimshape,'d',compression='gzip',chunks=dimshape,compression_opts=6,shuffle='true')
        ds[...] = fullSigDat[i-1]
    
        tagNam='CRTL_'+fullNamCrtl[i-1][0:6]
        dimshape=shape(fullCrtlDat[i-1])
        ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=6,shuffle='true')
        ds[...] = fullCrtlDat[i-1]
        
        print '-- Chan.#',i
    fstore.close()
    print 'done: Write HDF5'

print 'FINISH LOADing shot # '+str(shot)