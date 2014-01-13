import h5py
import scipy.io as sio
import pandas as pds
import pylab as plt
import numpy as np

def getShotmat(shot=118800,fnam=None,sendout=False,noFile=False,quiet=True):

    if (fnam==None):
        fnam = 'shot_'+str(shot)
    hold = sio.loadmat(fnam,appendmat=True,squeeze_me=True,struct_as_record=True)

    sigs = ['nela',
            'ip',
            'prad',
            'ptot',
            'NB1',
            'NB2',
            'icrh1',
            'icrh2',
            'bt',
            'she1']

    fstore = h5py.File('s'+str(shot)+'_wavs.h5','w')
    if not quiet:
        print len(sigs)
    if not noFile:
        if not quiet:
            print 'No HDF5'
        for i in xrange(len(sigs)):
            ds = fstore.create_dataset('y_'+sigs[i],hold['data'][sigs[i]][()]['y'][()].shape,'f',maxshape=(None))
            ds.write_direct(hold['data'][sigs[i]][()]['y'][()])
            ds = fstore.create_dataset('x_'+sigs[i],hold['data'][sigs[i]][()]['x0'][()].shape,'f',maxshape=(None))
            ds.write_direct(hold['data'][sigs[i]][()]['x0'][()])
        fstore.close()

    message = 'Completed download: '+str(shot)
    if sendout:
        print message
        return sigs,hold
    else:
        return message

def load2DICT(fNAM=None,fixSHE=True):
    if fNAM == None:
        print 'yeah'
    filIN = h5py.File(fNAM,'r')
    Names = filIN.keys()
    outDICT = {}
    for i in xrange(len(Names)):
        outDICT[Names[i]] = filIN[Names[i]].value
    if fixSHE:
        oldX=outDICT['x_she1']
        oldY=outDICT['y_she1']
        outDICT['x_she_corr']=oldX[:]+0.04
        outDICT['y_she_corr']=oldY[:]-np.mean(oldY[0:10])
    return outDICT

def mak2DFrame(shot,fNAM=None,quiet=True):
    if fNAM == None:
        print 'huh?'
        return
    sigs,outDICT = getShotmat(shot,fnam=fNAM,sendout=True)
    sigNum = len(sigs)
    dictHolder = {}
    for i in xrange(sigNum):
        if not quiet:
            print 'loading: {}'.format(sigs[i])
        dictHolder[sigs[i]] = pds.Series(data=outDICT['data'][sigs[i]][()]['y'][()],
            index=outDICT['data'][sigs[i]][()]['x0'][()],name=sigs[i])
    return dictHolder

def plotITup(shot,path=None,legON=True,quiet=True):
    if path == None:
        print 'you need to give me a path'
        print 'program stopped'
        return
    fNAM = path+'/shot_'+str(shot)+'.mat'
    oDICT = mak2DFrame(shot,fNAM=fNAM,quiet=quiet)
    smPNTs = 10.
    xlo=-0.2
    xhi=8.
    ylo=0.0
    yhi=0.75
    oDICT['she1'] +=np.mean(oDICT['she1']/oDICT['she1'].max(),0,100)
    oDICT['nela'] = oDICT['nela']/1.e20
    oDICT['ip'] = -1*oDICT['ip']/1000.
    oDICT['bt'] /= 10.
    oDICT['NB1'] /= 1.e6
    oDICT['NB2'] /= 1.e6
    oDICT['icrh1'] -= np.mean(oDICT['icrh1'],0,100)
    oDICT['icrh2'] -= np.mean(oDICT['icrh2'],0,100)
    plt.figure(figsize=(10,8))
    plt.subplot(2,1,1)
    oDICT['she1'].plot(label = 'SHE on',c='grey',legend=legON,alpha=0.5)
    oDICT['nela'].plot(label='nela [x10^20 m**3]',legend=legON,linewidth=2,c='r')
    oDICT['ip'].plot(label='Ip [MA]',legend=legON,linewidth=2,c='b')
    oDICT['bt'].plot(label='B_t [/10 T]',legend=legON,linewidth=2,c='k',ylim=(ylo,yhi),xlim=(xlo,xhi))
    plt.subplot(2,1,2)
    oDICT['she1'].plot(label='SHE on',legend=legON,linewidth=1,c='grey',ylim=(ylo,1.25))
    pds.rolling_mean(oDICT['NB1'],10*smPNTs).plot(label='NBI1 [MW]',legend=legON,linewidth=2,c='k')
    pds.rolling_mean(oDICT['NB2'],smPNTs).plot(label='NBI2 [MW]',legend=legON,linewidth=2,c='r')
    pds.rolling_mean(oDICT['icrh1'],10*smPNTs).plot(label='Gen1 [MW?]',legend=legON,linewidth=2,c='b')
    pds.rolling_mean(oDICT['icrh2'],2*smPNTs).plot(label='Gen2 [MW?]',legend=legON,linewidth=2,c='g',xlim=(xlo,xhi))
    plt.xlabel('time [sec]')
    return