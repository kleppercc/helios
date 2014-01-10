import h5py
import scipy.io as sio


def getShotmat(shot=118800,fnam=None):

    if fnam==None:
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
    dens = hold['data']['nela']
    ip = hold['data']['ip']
    prad=hold['data']['prad']
    nbi1=hold['data']['NB1']
    nbi2=hold['data']['NB2']
    she =hold['data']['she1']

    fstore = h5py.File('s'+str(shot)+'_wavs.h5','w')
    for i in xrange(0,len(sigs)):
        ds = fstore.create_dataset('y_'+sigs[i],hold['data'][sigs[i]][()]['y'][()].shape,'f',maxshape=(None))
        ds.write_direct(hold['data'][sigs[i]][()]['y'][()])
        ds = fstore.create_dataset('x_'+sigs[i],hold['data'][sigs[i]][()]['x0'][()].shape,'f',maxshape=(None))
        ds.write_direct(hold['data'][sigs[i]][()]['x0'][()])
    fstore.close()

    return 'Complete download: '+str(shot)

def load2DICT(fNAM):
    filIN = h5py.File(fNAM,'r')
    Names = filIN.keys()
    outDICT = {}
    for i in len(Names):
        outDICT[Names[i]] = filIN[Names[i]].value
    return outDICT
