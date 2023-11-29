# The second linear method is modelled in this file, the deviations are modelled using constraints

param N_days >= 0 integer;
param N_Consec >= 0 integer;

set WEEK:= 1..N_days circular;

param Req{WEEK} >= 0;

var X{WEEK} >=0 integer;
var Dev{WEEK}>=0; # Deviation variable

# Objective functions
minimize Total_Deviations: sum{w in WEEK} (Dev[w]);

# Constraints - The below to constraints exhibit the behavior of max(-excess, excess) 
subject to
Daily_roll1 {w in WEEK}: sum{j in 0..N_Consec-1}X[prev(w, WEEK, j)] - Req[w] <= Dev[w]; 
Daily_roll2 {w in WEEK}: -sum{j in 0..N_Consec-1}X[prev(w, WEEK, j)] + Req[w] <= Dev[w];