# Code for Q2a(iii)

param n_days >=0 integer;

param n_consecutive >=0 integer;

set day:= 1..n_days circular;

param requirement{day} >=0;

var X{day} >=0;
var A{day} >=0;

# Defining a parameter for Maximum excess in a day
var z;

# Objective function:
minimize slack: z;

# Constraints:
subject to

# Constraint - Maximum excess in a day >= Excess on any particular day of the week
	constraint{i in day}: z >= (A[i]-requirement[i]);
	
# Constraint - Workers on a particular day are greater than the requirement
	attendance{i in day}: A[i] >= requirement[i];
	
# Constraint - For linking A[i] and X[i]
	Actual{i in day}: sum{j in 0..n_consecutive-1} X[prev(i,day,j)] = A[i];