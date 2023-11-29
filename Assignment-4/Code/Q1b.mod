param N > 0 integer;				# Number of jobs
set JOBS := 1..N;				# Set of jobs
param P {JOBS} > 0;				# Processing times
param D {JOBS} > 0;				# Due dates
param M := sum {j in JOBS} P[j];	# Total time to process all jobs		
set TIME := 0..M;				# Set of time

var Z {JOBS, TIME} binary;		# Zjt = 1 if job j starts at time t, 0 otherwise
var C {JOBS};					# completion time
var T {JOBS};					# tardiness of job j

minimize Tardiness : sum {j in JOBS} T[j];
subject to

# a job can start at only one point in time
Single_start_time {j in JOBS} : sum {t in TIME} Z[j,t] = 1;

# no more than 1 jobs can start at a point in time
Max_one_job_at_a_time {t in TIME} : sum {j in JOBS} Z[j,t] <= 1;

# completion time of job j = processing time of job j + start time of job j
Completion_time {j in JOBS} : C[j] = P[j] + sum {t in TIME} t*Z[j,t];

# start time of job starting at t2 >= completion times of all jobs starting before t2 and ending by t2 
Completion_start_relationship {t1 in TIME, t2 in TIME : t1 < t2} : sum {j in JOBS} Z[j,t1]*(t1 + P[j]) <= (sum {j in JOBS} t2*Z[j,t2]) + M*(1 - sum {j in JOBS} Z[j,t2]); 

# T[j] = max (0, C[j] - D[j])
Tardiness_1 {j in JOBS} : T[j] >= 0;
Tardiness_2 {j in JOBS} : T[j] >= C[j] - D[j];