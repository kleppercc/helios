#******************************************************************************************
#*   Mfunction to load the tapete for lookup of line ratios and
#*   determination of ne and Te
#*
#*   written by o.schmitz, July 2004
#******************************************************************************************
#*
#*
#*   # Usage:
#*
#*   [ne_axis, Te_axis, ne_ratio_model, Te_ratio_model]=load_tapete(tapete_name);
#*
#*   # Input:    'tapete_name' :   is the filename of the tapete you would like to use
#*                                 - ./pcals/all_n_62_a.te_ne (Default and best proofed)
#*                                 - ./pcals/all_n_64_a.te_ne
#*                                 - ./pcals/gg_deheer_a.te_ne
#*   # Output:   'ne_axis'     :   Range of ne values in this tapete
#*               'Te_axis'     :   Range of Te values in this tapete
#*               'ne_ratio_model    :   Ratio array for the ne sensitive line ratios
#*               'Te_ratio_model    :   Ratio array for the Te sensitive line ratios
#*
#*****************************************************************************************

import numpy as np
import scipy as sp
from scipy import io as sio

#@mfunction("ne_axis, Te_axis, ne_ratio_model, Te_ratio_model")
def load_tapete(tapete_name='tapete_all_n_62_a.mat',quiet=0):

    #*** Load the tapete
    #*** Exist this data as mat file (loading is much, much faster)
    try:
        if quiet!=0:
        	print '----------------------------------------------------------'
        	print '------- Start loading of tapete from .mat.'
        #varnames = ['ne_axis','Te_axis','ne_ratio_model','Te_ratio_model']
        res_tap = sp.io.loadmat(tapete_name)
    except IOError:
        #*** Load tapete as dummy to test for number of lines
        #*** Matlab can not load it directly with 'load'!
        if quiet!=0:
        	print '----------------------------------------------------------'
        	print '------- Start loading of tapete. Please wait a moment'
        	print '--- Tapete used is: %s', tapete_name

    #test_lnum = sio.loadmat(tapete_name)
    #stest = np.shape(test_lnum)
    #lnum_tapete = stest[0]

    #    #*** Now load all lines with fgetl
    #    tap_data = np.zeros(lnum_tapete, 1)
    #    fid = fopen(tapete_name)
    #    #i = 0
    #    for i in xrange(0,lnum_tapete):
    #        tline = fgetl[fid]
    #        tap_data[i] = np.float(tline)
    #        #i = i + 1
    #    end

    #    #*** reshape the dataset
    #    #*** Each axis is 301 points!
    #    res_tap = np.reshape(tap_data,[301,604])

        #*** Create two axes for ne and te values
        #Te_axis = res_tap[:,0]
        #ne_axis = res_tap[:,1]
        #Te_ratio_model = res_tap[:,2:303]
        #ne_ratio_model = res_tap[:,303:604]
    Te_axis = res_tap['Te_axis']
    ne_axis = res_tap['ne_axis']
    Te_ratio_model = res_tap['Te_ratio_model']
    ne_ratio_model = res_tap['ne_ratio_model']

    if quiet!=0:
    	print '------- Finished loading tapete'

    return Te_axis, ne_axis, Te_ratio_model, ne_ratio_model