# Palop smoothing function
import numpy as np
import pylab as pl
import scipy.signal as scs

def smooth(wavIn,stdev=2.,fftmod=True,gterm=None,quiet=True):

	sampwid = len(wavIn)+10
	xs = np.arange(sampwid)-(sampwid/2.)

	alph = 1./(np.sqrt(2)*stdev)
	term1 = np.exp(-1*alph*alph*xs*xs)
	const = alph/np.sqrt(np.pi)
	if (gterm == 10):
		##### ten term expanded guassian
		g_tot = const*((10.*term1)-(45./np.sqrt(2)*term1**(1./2))+(120./np.sqrt(3)*term1**(1./3))-(105.*term1**(1./4))+((252./np.sqrt(5))*term1**(1./5))-
			(210./np.sqrt(6)*term1**(1./6))+(120./np.sqrt(7)*term1**(1./7))-(45./np.sqrt(8)*term1**(1./8))+(10./3*term1**(1./9))-(1./np.sqrt(10)*term1**(1./10)))
	if (gterm == 5):
		##### five term expanded guassian
		g_tot = const*((5.*term1)-(10./np.sqrt(2)*term1**(1./2))+(10./np.sqrt(3)*term1**(1./3))-(5./2*term1**(1./4))+((1./np.sqrt(5))*term1**(1./5)))
	if (gterm == 4) or (gterm == None):
		##### four term expanded guassian
		g_tot = const*((4.*term1)-(6./np.sqrt(2)*term1**(1./2))+(4./np.sqrt(3)*term1**(1./3))-((1./2)*term1**(1./4)))
	if (gterm == 2):
		##### two term expanded guassian
		g_tot = const*((2.*term1)-(1./np.sqrt(2)*term1**(1./2)))
	if (gterm == 1):
		##### single term expanded guassian
		g_tot = const*term1

	endrow = len(wavIn)
	wavOut = np.array(())
	for i in xrange(0,endrow,sampwid):
		start = i
		end = i+(sampwid)
		hold = wavIn[start:end]
		if (len(hold) != len(g_tot)):
			if not quiet:
				print "++++++++palop overrun++++++++++++"
			addon = len(g_tot) - len(hold)
			hold = np.append(hold,hold[-1]*np.ones(addon))
		if fftmod:
			holder = scs.fftconvolve(g_tot,hold,mode='same')
		else:
			holder = np.convolve(hold,g_tot,mode='same')
		wavOut = np.append(wavOut,holder)

	if (len(wavOut) > endrow): wavOut = wavOut[0:endrow]
	return wavOut

def plotem(xx,f_x,f_x_err,f_x_sm):
	pl.figure()
	pl.plot(xx,f_x_err,'g',linewidth=2)
	pl.plot(xx,f_x_sm,'k',linewidth=2)
	pl.plot(xx,f_x,'r',linewidth=2)

def example(pnts=None,stdev=2,plotIt=True,gterm=4):
		if (pnts == None):
			xs = -10+0.01*np.arange(1001)
		else:
			xs = -10+0.01*np.arange(pnts)
		f_x = 0.5*np.tanh(xs)+0.5
		f_x_err = f_x+np.random.uniform(-.1,.1,size=len(xs))
		f_x_sm = smooth(f_x_err,stdev=stdev,gterm=gterm)
		if plotIt:
			plotem(xs,f_x,f_x_err,f_x_sm)
