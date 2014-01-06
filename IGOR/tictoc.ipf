#pragma rtGlobals=1		// Use modern global access method.


Function tic()
	Variable/G tictoc = startMSTimer
End

Function toc()
	NVAR/Z tictoc
	Variable ttTime = stopMSTimer(tictoc)
	Printf "%g seconds \r", (ttTime/1e6)
	KillVariables/Z tictic
End