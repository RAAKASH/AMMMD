# Non Linear model
param N_days >= 0 integer;
param N_Consec >= 0 integer;

set WEEK:= 1..N_days circular;

param Req{WEEK} >= 0;

var X{WEEK} >=0 integer;
var Y{WEEK} >=0; # Attendance variable

minimize Total_Deviations: sum{w in WEEK} abs(Y[w]-Req[w]); #Non Linear Constraint
 
subject to
Daily_roll {w in WEEK}: sum{j in 0..N_Consec-1}X[prev(w, WEEK, j)] = Y[w]; # Attendance variable constraint