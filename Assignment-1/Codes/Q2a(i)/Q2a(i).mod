# Code for Q2a(i)

param n_days >=0 integer;

param n_consecutive >=0 integer;

set day:=1..n_days circular;

param requirement{day} >=0;

var X{day} >=0;
var A{day} >=0;

# Objective function:
minimize slack: max{j in day}(A[j]-requirement[j]);

# Constraints:
subject to 

# Constraint - For Linking A[i] and X[i]
Actual{i in day}: sum{j in 0..n_consecutive-1} X[prev(i,day,j)] = A[i];

# Constraint – Availability of workers on the day should be greater than requirement
demand{i in day}: sum{j in 0..n_consecutive-1} X[prev(i,day,j)] >= requirement[i];



