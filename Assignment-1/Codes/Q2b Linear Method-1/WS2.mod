# The first linear method is modelled in this file, X-excess+short = Req

param N_days >= 0 integer;
param N_Consec >= 0 integer;

set WEEK:= 1..N_days circular;

param Req{WEEK} >= 0;

var X{WEEK} >=0 integer;
var short{WEEK}>=0;  # Number of employees short on day "w"
var excess{WEEK}>=0; # Number of employees in excess on day "w"

# Objective Functions
minimize Total_Deviations: sum{w in WEEK} (short[w]+excess[w]);

# Constraints - The below constraint is the equation that equates the attendance to the Requirement using shortage and excess variables 
subject to
Daily_roll {w in WEEK}: sum{j in 0..N_Consec-1}X[prev(w, WEEK, j)] -excess[w]+short[w]= Req[w];