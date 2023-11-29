param N integer >0;
set JOBS := 0..N+1;

param NT {JOBS};#Non Crash time
param CN {JOBS};#Crash rate
param MT {JOBS};#Minimum time after crash
param CR {JOBS};#Crash rate per week
param PR {JOBS,JOBS};
param T;#Max time before penalty
param P;#penalty

param MR {j in JOBS} := NT[j] - MT[j];

var R{JOBS} >= 0;
var E{JOBS} >= 0;
var S{JOBS} >= 0;
var W >=0;

# New variables added to the model
var SL{JOBS}>=0 binary; #1 if job is critical, 0 if it is not
var SL_val{JOBS}; # Slack available for the Job

minimize Cost: sum {j in JOBS} (CN[j] + CR[j]*R[j]) + P*W ;
subject to

Crash_max {j in JOBS} : R[j] <= MR[j];
Precedence {i in JOBS, j in JOBS : PR[i,j] = 1} : S[j] >= E[i];
End_start {j in JOBS} : E[j] = S[j] + NT[j] - R[j];
End : W >=E[N+1] - T;

# Additional Constraints added to the model
Slack_Const1{i in JOBS, j in JOBS, k in JOBS:PR[i,j]=1 and PR[j,k]=1}:SL_val[j]= S[j]-E[i] +S[k]- E[j] ;
Slack_Const2{i in JOBS}:T*SL[i]>= SL_val[i];
Slack_Const3{i in JOBS}:SL[i]<= SL_val[i];
