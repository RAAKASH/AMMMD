## Section 1: Parameters and Sets

param n_inputs;
param n_processes;
param n_grades;

set INPUT:= 1..n_inputs;
set PROCESS:= 1..n_processes;
set GRADE:= 1..n_grades;

param pulp_content{INPUT};

param input_cost {INPUT};

param process_eff {PROCESS};

param process_cost {PROCESS};

param grade_demand {GRADE};

param process_capacity {PROCESS};

param feasibility {GRADE, INPUT};

## Section 2: Decision Variables

var Y{INPUT, PROCESS} >=0 ;			## tonnes of input i processed using process p
var X{INPUT, GRADE} >=0 ;			## tonnes of pulp produced from input i for grade g

## Section 3 Objective and Constraints

minimize cost: sum{i in INPUT, p in PROCESS} Y[i,p]*(input_cost[i]+process_cost[p]);	## minimize total cost

subject to

## total input processed using process p should be less than the capacity of process p 
Process_capacity{p in PROCESS}: sum{i in INPUT} Y[i,p] <= process_capacity[p];

## total output for grade g should be greater than or equal to the demand for grade g
Grade_demand{g in GRADE}: sum{i in INPUT} X[i,g] >= grade_demand[g];

## restrict the production of grade g to only the feasible inputs 
Feasibility{i in INPUT, g in GRADE}: X[i,g] <= feasibility[g,i]*grade_demand[g];

## pulp extracted from input i should be sufficient to fulfil the allocation across grades
Input_output{i in INPUT}: sum{p in PROCESS} Y[i,p]*pulp_content[i]*process_eff[p] >= sum{g in GRADE} X[i,g];
