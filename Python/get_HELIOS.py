"""
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# function to read data out of MDS+ from Filterscope computer and write ASCII or HDF5 files 
# 
# Orignally written in python v2.6 on 03/21/2011 by EAU
# 
# Brief:
# 		This program will output HFDF5 and ASCII files from an MDS+ server tree. This allows
#		data from filterscope to be input and reproduced in analysis programs, eg IDL, 
#		MatLab, IGORPro, or python, and/or allows the data to be stored in non-MDS+ storage
#		archives, eg, TEXTOR TWU system.
#
#  
# Useage: 
#		interactive: run get_HELIOS.py shot write_files
#		terminal command line: python get_fsmid.py shot write_netCDF throw_IGORPRO grabraw
#
#		shot = int shot number
#		write_files = 0 no; 1 yes :: writes acsii and HDF5 files for loading into server or 
#									 analysis program.
#		quiet = 0 no; 1 yes 	  :: turns off command line messages; usually needed for 
#									 debugging only.
# 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"""
import sys
from numpy import *
from scipy import *

import MDSplus as mds

####### Warning Suppression #####
#Needed for warning suppression at the moment
import warnings
warnings.simplefilter('ignore', DeprecationWarning)
####### End Warning Load ########

make_raw = int(sys.argv[1])
make_tBase = int(sys.argv[2])
write_files = int(sys.argv[3])
SHOT = int(sys.argv[4])  #138767

####### String & Variable Definitions
ServerName = 'localhost'
TreeName = 'helios'

tubeNum = 48
####### End String Define #####

#mds.Connection(ServerName)
TreeObj = mds.Tree(TreeName,SHOT,'EDIT') 

####### Grab data #######
#==== Get common digitizer information ====
T_START = round(TreeObj.getNode('TRIGGER').data(),3)
DELAY = round(TreeObj.getNode('DELAY').data(),6)
DIG_FREQ = round(TreeObj.getNode('FREQ').data(),6)
SAMPLES = round(TreeObj.getNode('NUM_SAMPLES').data(),3)
#==========================================

FILTFLUXarr = ones((SAMPLES,tubeNum))
PMTRAWarr = ones((SAMPLES,tubeNum))

for j in range(1,tubeNum+1):
    if j < 10:
        PMTstr='TUBE0'+str(j)
        CTRLstr='TUBE0'+str(j)
    else:
        PMTstr='TUBE'+str(j)
        CTRLstr='TUBE'+str(j)

    pmtNode = TreeObj.getNode(':'+PMTstr).getNode('PMT_VOLT')
    ctrlNode = TreeObj.getNode(':'+PMTstr).getNode('PMT_CTRL')
    calpmtNode = TreeObj.getNode(':'+PMTstr).getNode('CAL_PMT')
    calctrlNode = TreeObj.getNode(':'+PMTstr).getNode('CAL_CTRL')
    gampNode = TreeObj.getNode(':'+PMTstr).getNode('GAIN')
    innumNode = TreeObj.getNode(':'+PMTstr).getNode('FS_COEFF_I_N')
    c0Node = TreeObj.getNode(':'+PMTstr).getNode('PMT_COEFFA0')
    c1Node = TreeObj.getNode(':'+PMTstr).getNode('PMT_COEFFA1')
    c2Node = TreeObj.getNode(':'+PMTstr).getNode('PMT_COEFFA2')
    c3Node = TreeObj.getNode(':'+PMTstr).getNode('PMT_COEFFA3')
    describNode = TreeObj.getNode(':'+PMTstr).getNode('PMT_DESC')

    V_PMT = pmtNode.getData().data()
    V_CTRL = round(mean(ctrlNode.getData().data()),3)
    V_PMT_CAL = round(calpmtNode.getData().value,3)
    V_CTRL_CAL = round(calctrlNode.getData().value,3)
    G_AMP = round(gampNode.getData().value,3)
    InherNum = round(innumNode.getData().value,3)    
    C0 = round(c0Node.getData().value,3)
    C1 = round(c1Node.getData().value,3)
    C2 = round(c2Node.getData().value,3)
    C3 = round(c3Node.getData().value,3)
    PMT_DESC = describNode.getData().value

    if j == 1:
        DESCarr = tubeNum*[PMT_DESC]
    else:
        DESCarr[j-1] = PMT_DESC

    TEMP1 = log(C0+(C1*V_CTRL_CAL)+(C2*V_CTRL_CAL)**2+(C3*V_CTRL_CAL)**3)
    G_CAL = round(abs(TEMP1),2)
    TEMP2 = log(C0+(C1*V_CTRL)+(C2*V_CTRL)**2+(C3*V_CTRL)**3)
    G_PMT = round(abs(TEMP2),2)
    V_BL = round(mean(V_PMT[0:1000]),4)
    if V_PMT_CAL == 0:
        V_PMT_CAL = 999999999.
    hold = InherNum*(G_CAL/(G_AMP*G_PMT*V_PMT_CAL))*(V_PMT - V_BL)
    FILTFLUXarr[:,j-1] = hold

    if make_raw == 1:
        PMTRAWarr[:,j-1] = V_PMT
    
    compl = j/tubeNum
    sys.stdout.write('\r')
    sys.stdout.write("[%-48s] %d%%" % ('='*j,((j/48.)*100)))
    sys.stdout.flush()

if make_tBase == 1:    
    start = round((T_START+DELAY),3)
    stop = round(T_STAR+DELAY+(SAMPLES*DIG_FREQ),3)
    tBase = arange(start,stop,DIG_FREQ)
####### Done with server connection ####

if write_files == 1:        
    # Write a HDF5 file
    print '\n---START: write HDF5---'
    from h5py import *
    
    fil = File('HeliosFS_'+str(SHOT)+'.h5','w')
    
    # ---- Dig. Settings -----
    #tagNam='AD_Gain'
    #dimshape=shape(ADGAIN)
    #ds = fil.create_dataset(tagNam,dimshape,'f')
    #ds[...] = ADGAIN
    tagNam='t_Delay'
    dimshape=shape(DELAY)
    ds = fil.create_dataset(tagNam,dimshape,'f')
    ds[...] = DELAY
    tagNam='Samples'
    dimshape=shape(SAMPLES)
    ds = fil.create_dataset(tagNam,dimshape,'i')
    ds[...] = SAMPLES
    tagNam='t_Trigger'
    dimshape=shape(T_START)
    ds = fil.create_dataset(tagNam,dimshape,'f')
    ds[...] = T_START
    tagNam='DEL_t'
    dimshape=shape(DIG_FREQ)
    ds = fil.create_dataset(tagNam,dimshape,'f')
    ds[...] = DIG_FREQ
    #-------------------------- 
    
    tagNam='PMTDESC_array'
    dimshape=shape(DESCarr)
    dt = special_dtype(vlen=str)
    ds = fil.create_dataset(tagNam,dimshape,dtype=dt,compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = DESCarr
    
    tagNam='FILTFLUX_array'
    dimshape=shape(FILTFLUXarr)
    ds = fil.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
    ds[...] = FILTFLUXarr
    
    if make_raw == 1:
        tagName='PMTraw_array'
        dimshape=shape(PMTRAWarr)
        ds = fil.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
        ds[...] = PMTRAWarr
    
    if make_tBase == 1:
    	tagNam='tBase'
        dimshape=shape(tBase)
        ds = fil.create_dataset(tagNam,dimshape,'f',compression='gzip',chunks=dimshape,compression_opts=9,shuffle='true')
        ds[...] = tBase
    fil.close()
    print '---DONE: write HDF5---'
print 'Done: Sehr Gut', SHOT