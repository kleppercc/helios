import sys
from numpy import *
from scipy import *

from pmds import *

#Needed for warning suppression at the moment
import warnings
warnings.simplefilter('ignore', DeprecationWarning)

write_HDF = int(sys.argv[1])
chanNum = int(sys.argv[2]) # from 2-49
shot = int(sys.argv[3])  #138767

mdsconnect('134.94.245.16')
mdsopen('HELIOS', shot)

#==== Get common digitizer information ====
Var0=':ADGAIN'
ADGAIN = mdsvalue(Var0)
#print 'A/D RESOLU: %s [V/bit]' %ADGAIN
Var1=':DELAY'
DELAY = mdsvalue(Var1)

#----Hardwired until fixed ----
Var2 = ':FREQ'
DIG_FREQ = mdsvalue(Var2)
#print 'DEL_T:',DIG_FREQ

Var3 = ':NUM_SAMPLES'
SAMPLES = mdsvalue(Var3)
#print 'NUM_SAMPS:',SAMPLES
Var4 = ':TRIGGER'
T_START = mdsvalue(Var4)
#print 'DELAY, TRIG:', DELAY,T_START
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
        sigNam=':TUBE0'+str(i)+':PMT_VOLT'
        crtlNam=':TUBE0'+str(i)+':PMT_CTRL'
        gainNam=':TUBE0'+str(i)+':GAIN'
        sigTex=':TUBE0'+str(i)+':PMT_DESC'
    else:
        sigNam=':TUBE'+str(i)+':PMT_VOLT'
        crtlNam=':TUBE'+str(i)+':PMT_CTRL'
        gainNam=':TUBE'+str(i)+':GAIN'
        sigTex=':TUBE'+str(i)+':PMT_DESC'
    
    fullNamSig.append(sigNam)
    fullNamCrtl.append(crtlNam)
    fullNamGain.append(gainNam)
    fullSigDesc.append(sigTex)
    
for i in range(1,chanNum):
    gaindat = mdsvalue(fullNamGain[i-1])
    fullGainVar.append(gaindat)
    
    sigdat = mdsvalue(fullNamSig[i-1])
    fullSigDat.append(sigdat)
    
    crtldat = mdsvalue(fullNamCrtl[i-1])
    fullCrtlDat.append(crtldat)
    
    desctex = mdsvalue(fullSigDesc[i-1])
    fullDescTex.append(desctex)
    print '-- Chan.#',i
    
mdsclose('HELIOS',shot)
mdsdisconnect

print 'stop: Data Grab'
#++++++++++++++++++++++++++++++++++++++++++++++

#------------ Write HDF5 file -----------------
if write_HDF == 1:
    print 'START: Write HDF5'
    from h5py import *

    fstore = File('TEXTOR_data/s'+str(shot)+'.h5','w')

    # ---- Dig. Settings -----
    tagNam='AD_Gain'
    dimshape=shape(ADGAIN)
    ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = ADGAIN
    tagNam='t_Delay'
    dimshape=shape(DELAY)
    ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = DELAY
    tagNam='NumPnts'
    dimshape=shape(SAMPLES)
    ds = fstore.create_dataset(tagNam,dimshape,'i',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = SAMPLES
    tagNam='t_Trigger'
    dimshape=shape(T_START)
    ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = T_START
    tagNam='DEL_t'
    dimshape=shape(DIG_FREQ)
    ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
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
        tagNam='VOLT_'+fullNamSig[i-1][1:7]
        dimshape=shape(fullSigDat[i-1])
        ds = fstore.create_dataset(tagNam,dimshape,'d',compression='gzip',chunks=dimshape,compression_opts=6,shuffle='true')
        ds[...] = fullSigDat[i-1]
    
        tagNam='CRTL_'+fullNamCrtl[i-1][1:7]
        dimshape=shape(fullCrtlDat[i-1])
        ds = fstore.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=6,shuffle='true')
        ds[...] = fullCrtlDat[i-1]
        
        print '-- Chan.#',i
    fstore.close()
    print 'done: Write HDF5'

print 'FINISH LOADing shot # '+str(shot)