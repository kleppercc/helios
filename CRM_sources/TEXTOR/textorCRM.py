#==== Documentation =====
#
import sys
import numpy as np
import load_tapete as LTP
import lookup_neTe as LNT

[Te_axis, ne_axis, Te_ratio_model, ne_ratio_model] = LTP.load_tapete('tapete_all_n_62_a.mat',0)

SHOT = np.int(sys.argv[1])
Te_min = np.float(sys.argv[2])
Te_max = np.float(sys.argv[3])
ne_min = np.float(sys.argv[4])
ne_max = np.float(sys.argv[5])

rne = np.float(sys.argv[6])
rTe = np.float(sys.argv[7])

#*** Define boundaries for ne and te values
#   Shotnumber  Te_min  Te_Max    ne_Min      ne_Max
#	 115000       5       500     1.0*10^18   6.0*10^19
BoundVal=[SHOT,Te_min,Te_max,ne_min,ne_max];

#--- look up data
ne_He,Te_He = LNT.lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, rne, rTe, BoundVal,quiet=0);

print ne_He
print Te_He