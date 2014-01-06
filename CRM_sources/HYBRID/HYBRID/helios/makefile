#
#
#								2008 aug 04
# Makefile to build fortran program with Intel Fortran (ifort) 
# on the zeus.gat.com Linux machine.
# REFERENCE:  man ifort  in Linux

PROGRAM = helios.x
SOURCES = helios.f eqmodel.f tdmodel.f tdmodel_fast.f

#LIBRARY = -llapack
#LIBRARY = ../LIBRARY/trip3d.ifort.so

# Some Intel Fortran 95 ifort compiler options:
# -w suppresses all compilation warnings. -w90,-w95 suppresses warnings
#	that about features that are obsolete or deprecated in f90,f95.
# -C enables extensive runtime diagnostics options.
# -g generates symbolic debugging info, line #s for source-level debuggers.
# -mp maintains declared floating point precision (may slow execution).
# -Kpic generates position-independent code. IA-32 only.
# -tpp7 optimizes for Pentium 4 & Xeon processors.
# -unroll[n] sets max # of times to unroll a loop. Omit n lets the compiler
#	decide whether to perform unrolling or not. Use n=0 to disable unroll.
#	PGF95's related -Munroll caused problems in some nested DO loops.
# -03 Optimization level 3
# LIBS =	-llapack 

 OBJECTS = $(SOURCES:.f=.o)
 DEBUG	 = -g  					# -C -mp -w90 -w95 'fast'
#DEBUG	 = -g  -C				# -C -mp -w90 -w95 'slow'

 OPTIMIZE = -O3 -tpp7 -unroll -Kpic				# 'fast'

LISTING   =
#   In the line above, there is NOTHING after "="

#SPECIAL   = -save	## Don't use -save; it is not portable.
# -save saves variables (static allocation) except local variables
#       within a recursive routine; opposite of -auto.

# Compile with Itel Fortran Compiler
#COMPILE  = ifort -c    $(OPTIMIZE)  $(LISTING) $(SPECIAL)  	# 'fast'
COMPILE  = gfortran -c -fbacktrace -g -fPIC  $(DEBUG)     $(LISTING) $(SPECIAL)	# 'slow'

LOAD       = gfortran -o $(PROGRAM) -fPIC

PROTECT   = chmod 0755

.SUFFIXES:
.SUFFIXES: .f .o

$(PROGRAM):        $(OBJECTS) $(LIBRARY)
	$(LOAD)    $(OBJECTS) $(LIBRARY)
	$(PROTECT) $(PROGRAM)

.f.o:
	$(COMPILE) -I../INCLUDE $<

clean:
	rm -f $(PROGRAM) *.o *.lst
