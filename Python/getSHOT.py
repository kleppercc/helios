import h5py
import scipy.io as sio

def getShotmat(shot=118800,fnam=None):

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
    print len(sigs)
    for i in xrange(len(sigs)):
        ds = fstore.create_dataset('y_'+sigs[i],hold['data'][sigs[i]][()]['y'][()].shape,'f',maxshape=(None))
        ds.write_direct(hold['data'][sigs[i]][()]['y'][()])
        ds = fstore.create_dataset('x_'+sigs[i],hold['data'][sigs[i]][()]['x0'][()].shape,'f',maxshape=(None))
        ds.write_direct(hold['data'][sigs[i]][()]['x0'][()])
    fstore.close()

    message = 'Complete download: '+str(shot)
    return message

def load2DICT(fNAM=None):
    if fNAM == None:
        print 'yeah'
    filIN = h5py.File(fNAM,'r')
    Names = filIN.keys()
    outDICT = {}
    for i in xrange(len(Names)):
        outDICT[Names[i]] = filIN[Names[i]].value
    return outDICT
