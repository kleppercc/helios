#==== Documentation =====
#*** Define boundaries for ne and te values
#   Shotnumber  Te_min  Te_Max    ne_Min      ne_Max
#	 115000       5       500     1.0*10^18   6.0*10^19
#
#========================
import load_tapete as LTP
import lookup_neTe as LNT

def run(SHOT,rne,rTe,Te_min=5.,Te_max=500.,ne_min=1.e18,ne_max=6.e19):
	[Te_axis, ne_axis, Te_ratio_model, ne_ratio_model] = LTP.load_tapete('tapete_all_n_62_a.mat')
	BoundVal=[SHOT,Te_min,Te_max,ne_min,ne_max];
	#--- look up data
	ne_He,Te_He = LNT.lookup_neTe(ne_axis, Te_axis, ne_ratio_model, Te_ratio_model, rne, rTe, BoundVal);
	return {'ne':ne_He,'Te':Te_He