// F1 Connection Process

\l p.q
p)from f1_telemetry.server import *

h:hopen `::3030; // Open a connection to the In Memory data process

// dd is used for debug and keeps a list of the last messages of each type
dd:()!();
dd[`DUMMY]:();

//
// @name initialiselogfile
// @desc Initialises the event logfile and opens the handle
//
initialiselogfile:{[]
    logFile:`$":kx-telemetry-f1game-",(string .z.D),".eventlog";
    logFile set ();
    numMsgs::0;
    fileHandle::hopen logFile;
 };
//
// @name f1callback
// @desc This function is called each time a UDP mesasges is received by the system
//
// @param t  {symb}		    Symbol representing the message type.
// @param d  {dictionary}	An unstructured dictionary built directly from the python objects.
//
f1callback:{[t;d] 
		// 0N!(h;t); // Enable to view some debug
		dd[`$t]:d;
        fileHandle@enlist(`upd;`$t;.z.p;d);
        numMsgs+:1;
		h(`upd;`$t;.z.p;d); // Currently using sync calls as there seemed by issues using async. //neg[h](`upd;t;.z.p;d);
	};

// Register callback function with python & initiate
.p.set[`f1callback] f1callback;
p)callbacktel(f1callback)