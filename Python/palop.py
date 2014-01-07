# Palop smoothing function
import numpy as np
import pylab as pl
import scipy.signal as scs

def smooth(wavIn,sampwid=100,stdev=2.):

	xs = np.arange(sampwid)-(sampwid/2)

#  	   Make/O/N=2001 xs, f_x, f_x_err, f_x_sm
# //	   xs=-10+0.01*p
# //      f_x=0.5*tanh(xs)+0.5
# //      SetRandomSeed .5
# //      f_x_err=f_x+enoise(.1)

	alph = 1./(np.sqrt(2)*stdev)
	term1 = np.exp(-alph**2*xs**2)
	const = alph/np.sqrt(np.pi)
	g_tot = const*(4.*term1-(6./np.sqrt(2))*term1**(1./2)+(4./np.sqrt(3))*term1**(1./3)-(1./2)*term1**(1./4))

	endrow = len(wavIn)
	wavOut = np.array(())

	for i in xrange(0,endrow,sampwid):
		hold = wavIn[i:i+sampwid]
		if (len(hold) != len(g_tot)):
			addon = len(g_tot) - len(hold)
			hold = np.append(hold,np.zeros(addon))
		#holder = np.convolve(hold,g_tot,mode='same')
		holder = scs.fftconvolve(hold,g_tot,mode='same')
		wavOut = np.append(wavOut,holder)

	if (len(wavOut) > endrow): wavOut = wavOut[0:endrow]
	return wavOut

def plotem(xx,f_x,f_x_err,f_x_sm):
	pl.figure()
	pl.plot(xx,f_x_err,'g')
	pl.plot(xx,f_x_sm,'k')
	pl.plot(xx,f_x,'r',linewidth=3)