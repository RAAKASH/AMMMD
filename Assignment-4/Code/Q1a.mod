param N > 0 integer;				# Number of jobs
set JOBS := 1..N;				# Set of jobs
param P {JOBS} > 0;				# Processing times
param D {JOBS} > 0;				# Due dates

var Z {JOBS, JOBS} binary;		# Zij = 1 if job i is processed before j, 0 otherwise
var C {JOBS};					# completion time
var T {JOBS};					# tardiness of job j

minimize Tardiness : sum {j in JOBS} T[j];
subject to

# num of successors + num of predecessors = N-1
Successors_and_predecessors {j in JOBS} : sum {k in JOBS} Z[j,k] + sum {l in JOBS} Z[l,j] = N-1;

# completion time of job j = sum of processing times of all preceding jobs 
Completion_time {j in JOBS} : C[j] = P[j] + sum {i in JOBS} P[i]*Z[i,j];

# if job i is processed before j (Z[i,j] = 1), the number of predecessors of job j is at least 1 more than that of job i
Unequal_predecessors_1 {i in JOBS, j in JOBS : i>j} : sum {k in JOBS} (Z[k,j] - Z[k,i]) >= 1 - N*(1 - Z[i,j]);

# if job i is processed after j (Z[i,j] = 0), the number of predecessors of job j is at least 1 less than that of job i
Unequal_predecessors_2 {i in JOBS, j in JOBS : i>j} : sum {k in JOBS} (Z[k,j] - Z[k,i]) <= -1 + N*Z[i,j];  

# T[j] = max (0, C[j] - D[j])
Tardiness_1 {j in JOBS} : T[j] >= 0;
Tardiness_2 {j in JOBS} : T[j] >= C[j] - D[j];