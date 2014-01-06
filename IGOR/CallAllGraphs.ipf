#pragma rtGlobals=1		// Use modern global access method.

Menu "Control"
	   "Close All Graphs /9",CloseAllGraphs()
End
Function CloseAllGraphs()
	String name
		do
			name= WinName(0,1)	// name of the front graph
				if(strlen(name)==0)
					break
				endif
				DoWindow/K $name // Close the graph
		while(1)
End