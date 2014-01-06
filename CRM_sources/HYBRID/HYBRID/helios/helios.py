#++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Python port of J. Munoz Burgos Hybrid CRM
#	Detail of model in reference: J. Munoz, PoP 2012
#
#	Date: March 1, 2013
#
#	Usage:
#		python hybridCRM.py
##+++++++++++++++++++++++++++++++++++++++++++++++++++

import numpy as np
import h5py,sys

import tCRM
import tCRMf
import eqCRM

use_recomb = 1
skippnts = 0.

print 'Load Data'

print sys.argv[1]
tbase = np.int(sys.argv[1])
fnam_in = '/Users/unterbee/Desktop/hybridCRM/HeInts_'+str(tbase)+'.h5'
data = h5py.File(fnam_in,'r')

I667 = np.array(data['I667'].value,copy=True,order='C')
I706 = np.array(data['I706'].value,copy=True,order='C')
I728 = np.array(data['I728'].value,copy=True,order='C')

dI667 = np.array(data['dI667'].value,copy=True,order='C')
dI706 = np.array(data['dI706'].value,copy=True,order='C')
dI728 = np.array(data['dI728'].value,copy=True,order='C')

radius = np.array(data['radius_igor'].value,copy=True,order='C')

#---Thermal Beam Parameters---
#beam velocity
if(data.__contains__('vbeam')):
	vb = float(data['vbeam'].value)
else:
	vb=1.5e3
#nozzle location relative to viewchords
if(data.__contains__('r0')):
	r0 = float(data['r0'].value)
else:
	r0 = 0.55
#reference density
if(data.__contains__('neref')):
	Ne_ref = float(data['neref'].value)
else:
	Ne_ref = 1.0e12

data.close()

print 'Calculating Te and Ne with the Equilibruim Model'

[Te_exp,Ne_exp,dTe_exp,dNe_exp] = eqCRM.eqmodel(I667,I706,I728,dI667,dI706,dI728)

print 'Calculating Te and Ne with Time_dependent Model'

if(use_recomb==0):
	[Tet_exp,Net_exp,dTet_exp,dNet_exp] = tCRM.tdmodel(vb,r0,radius,I667,I706,I728,dI667,dI706,dI728)
elif(use_recomb==1):
	[Tet_exp,Net_exp,dTet_exp,dNet_exp] = tCRMf.tdmodel_fast(vb,r0,radius,I667,I706,I728,dI667,dI706,dI728)
else:
	print 'no data'

#============================================================
# This is to descriminate points from the TD model that are
# at higher densitites.
#============================================================
chi_te_ne_o = np.inf
nexp = len(radius)

for n in xrange(0,nexp):
	chi_te_ne = (1.0 - Tet_exp[n]/Te_exp[n])**2 + (1.0 - Net_exp[n]/Ne_exp[n])**2
	if((Net_exp[n] > Ne_ref) & (n > skippnts)):
		if(chi_te_ne < chi_te_ne_o):
			chi_te_ne_o  = chi_te_ne
		else:
			ndt = n -1
			break

for n in xrange(0,ndt):
	Te_exp[n] = Tet_exp[n]
	dTe_exp[n,0:1] = dTet_exp[n,0:1]

	if(Net_exp[n] < Ne_exp[n]):
		Ne_exp[n] = Net_exp[n]
		dNe_exp[n,0:1] = dNet_exp[n,0:1]

fnam_out = '/Users/unterbee/Desktop/hybridCRM/TeNe_'+str(tbase)+'.h5'
with h5py.File(fnam_out,'w') as f:
	dset = f.create_dataset('Radius',radius.shape,radius.dtype,maxshape=(None))
	dset.write_direct(radius)
	dset.attrs['units'] = 'm'
	dset = f.create_dataset('Te',Te_exp.shape,Te_exp.dtype,maxshape=(None))
	dset.write_direct(Te_exp)
	dset.attrs['units'] = 'eV'
	dset = f.create_dataset('dTe_p',dTe_exp[:,0].shape,dTe_exp.dtype,maxshape=(None))
	dset.write_direct(dTe_exp[:,0])
	dset.attrs['units'] = 'eV'
	dset = f.create_dataset('dTe_n',dTe_exp[:,1].shape,dTe_exp.dtype,maxshape=(None))
	dset.write_direct(dTe_exp[:,1])
	dset.attrs['units'] = 'eV'
	dset = f.create_dataset('n_e',Ne_exp.shape,Ne_exp.dtype,maxshape=(None))
	dset.write_direct(Ne_exp*1e6)
	dset.attrs['units'] = 'cm^-3'
	dset = f.create_dataset('dNe_p',dNe_exp[:,0].shape,dNe_exp.dtype,maxshape=(None))
	dset.write_direct(dNe_exp[:,0]*1e6)
	dset.attrs['units'] = 'm^-3'
	dset = f.create_dataset('dNe_n',dNe_exp[:,1].shape,dNe_exp.dtype,maxshape=(None))
	dset.write_direct(dNe_exp[:,1]*1e6)
	dset.attrs['units'] = 'cm^-3'

print 'Done'