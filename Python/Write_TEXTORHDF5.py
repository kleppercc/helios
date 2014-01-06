import sys
from numpy import *
from scipy import *

from pmds import *

#Needed for warning suppression at the moment
import warnings
warnings.simplefilter('ignore', DeprecationWarning)

shot = int(sys.argv[1])  #138767
write_HDF = int(sys.argv[2])
chanNum = int(sys.argv[3]) #'e8099'
freqVal = int(sys.argv[4])

mdsconnect('134.94.245.16')
mdsopen('HELIOS', shot)

# Get common digitizer information
Var1=':DELAY'
DELAY = mdsvalue(Var1)

#----Hardwired until fixed ----
#Var2 = ':FREQ'
#DIG_FREQ = mdsvalue(Var2)
DIG_FREQ = 1/freqVal

Var3 = ':NUM_SAMPLES'
SAMPLES = mdsvalue(Var3)
Var4 = ':TRIGGER'
T_START = mdsvalue(Var4)

print "START: data grab"

fullnamsig=[]
fullsigdat=[]

fullnamcrtl=[]
fullcrtldat=[]

fullnamgain=[]
fullgainvar=[]

#for i in range

signame=':TUBE01:PMT_VOLT'
TUBE01_PMT = mdsvalue(signame)
ctrlname=':TUBE01:PMT_CTRL'
TUBE01_CTRL = mdsvalue(ctrlname)
gainname=':TUBE01:GAIN'
TUBE01_GAIN = mdsvalue(gainname)
print 1

signame=':TUBE02:PMT_VOLT'
TUBE02_PMT = mdsvalue(signame)
ctrlname=':TUBE02:PMT_CTRL'
TUBE02_CTRL = mdsvalue(ctrlname)
gainname=':TUBE02:GAIN'
TUBE02_GAIN = mdsvalue(gainname)
print 2

signame=':TUBE03:PMT_VOLT'
TUBE03_PMT = mdsvalue(signame)
ctrlname=':TUBE03:PMT_CTRL'
TUBE03_CTRL = mdsvalue(ctrlname)
gainname=':TUBE03:GAIN'
TUBE03_GAIN = mdsvalue(gainname)
print 3

signame=':TUBE04:PMT_VOLT'
TUBE04_PMT = mdsvalue(signame)
ctrlname=':TUBE04:PMT_CTRL'
TUBE04_CTRL = mdsvalue(ctrlname)
gainname=':TUBE04:GAIN'
TUBE04_GAIN = mdsvalue(gainname)
print 4

signame=':TUBE05:PMT_VOLT'
TUBE05_PMT = mdsvalue(signame)
ctrlname=':TUBE05:PMT_CTRL'
TUBE05_CTRL = mdsvalue(ctrlname)
gainname=':TUBE05:GAIN'
TUBE05_GAIN = mdsvalue(gainname)
print 5

signame=':TUBE06:PMT_VOLT'
TUBE06_PMT = mdsvalue(signame)
ctrlname=':TUBE06:PMT_CTRL'
TUBE06_CTRL = mdsvalue(ctrlname)
gainname=':TUBE06:GAIN'
TUBE06_GAIN = mdsvalue(gainname)
print 6

signame=':TUBE07:PMT_VOLT'
TUBE07_PMT = mdsvalue(signame)
ctrlname=':TUBE07:PMT_CTRL'
TUBE07_CTRL = mdsvalue(ctrlname)
gainname=':TUBE07:GAIN'
TUBE07_GAIN = mdsvalue(gainname)
print 7

signame=':TUBE08:PMT_VOLT'
TUBE08_PMT = mdsvalue(signame)
ctrlname=':TUBE08:PMT_CTRL'
TUBE08_CTRL = mdsvalue(ctrlname)
gainname=':TUBE08:GAIN'
TUBE08_GAIN = mdsvalue(gainname)
print 8

signame=':TUBE09:PMT_VOLT'
TUBE09_PMT = mdsvalue(signame)
ctrlname=':TUBE09:PMT_CTRL'
TUBE09_CTRL = mdsvalue(ctrlname)
gainname=':TUBE09:GAIN'
TUBE09_GAIN = mdsvalue(gainname)
print 9

signame=':TUBE10:PMT_VOLT'
TUBE10_PMT = mdsvalue(signame)
ctrlname=':TUBE10:PMT_CTRL'
TUBE10_CTRL = mdsvalue(ctrlname)
gainname=':TUBE10:GAIN'
TUBE10_GAIN = mdsvalue(gainname)
print 10

signame=':TUBE11:PMT_VOLT'
TUBE11_PMT = mdsvalue(signame)
ctrlname=':TUBE11:PMT_CTRL'
TUBE11_CTRL = mdsvalue(ctrlname)
gainname=':TUBE11:GAIN'
TUBE11_GAIN = mdsvalue(gainname)
print 11

signame=':TUBE12:PMT_VOLT'
TUBE12_PMT = mdsvalue(signame)
ctrlname=':TUBE12:PMT_CTRL'
TUBE12_CTRL = mdsvalue(ctrlname)
gainname=':TUBE12:GAIN'
TUBE12_GAIN = mdsvalue(gainname)
print 12

signame=':TUBE13:PMT_VOLT'
TUBE13_PMT = mdsvalue(signame)
ctrlname=':TUBE13:PMT_CTRL'
TUBE13_CTRL = mdsvalue(ctrlname)
gainname=':TUBE13:GAIN'
TUBE13_GAIN = mdsvalue(gainname)
print 13

signame=':TUBE14:PMT_VOLT'
TUBE14_PMT = mdsvalue(signame)
ctrlname=':TUBE14:PMT_CTRL'
TUBE14_CTRL = mdsvalue(ctrlname)
gainname=':TUBE14:GAIN'
TUBE14_GAIN = mdsvalue(gainname)
print 14

signame=':TUBE15:PMT_VOLT'
TUBE15_PMT = mdsvalue(signame)
ctrlname=':TUBE15:PMT_CTRL'
TUBE15_CTRL = mdsvalue(ctrlname)
gainname=':TUBE15:GAIN'
TUBE15_GAIN = mdsvalue(gainname)
print 15

signame=':TUBE16:PMT_VOLT'
TUBE16_PMT = mdsvalue(signame)
ctrlname=':TUBE16:PMT_CTRL'
TUBE16_CTRL = mdsvalue(ctrlname)
gainname=':TUBE16:GAIN'
TUBE16_GAIN = mdsvalue(gainname)
print 16

signame=':TUBE17:PMT_VOLT'
TUBE17_PMT = mdsvalue(signame)
ctrlname=':TUBE17:PMT_CTRL'
TUBE17_CTRL = mdsvalue(ctrlname)
gainname=':TUBE17:GAIN'
TUBE17_GAIN = mdsvalue(gainname)
print 17

signame=':TUBE18:PMT_VOLT'
TUBE18_PMT = mdsvalue(signame)
ctrlname=':TUBE18:PMT_CTRL'
TUBE18_CTRL = mdsvalue(ctrlname)
gainname=':TUBE18:GAIN'
TUBE18_GAIN = mdsvalue(gainname)
print 18

signame=':TUBE17:PMT_VOLT'
TUBE17_PMT = mdsvalue(signame)
ctrlname=':TUBE17:PMT_CTRL'
TUBE17_CTRL = mdsvalue(ctrlname)
gainname=':TUBE17:GAIN'
TUBE17_GAIN = mdsvalue(gainname)
print 17

mdsclose('HELIOS',shot)
mdsdisconnect
from pylab import *