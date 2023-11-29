#Number of cities
param N;
param m;
#Minimum coverage
param min_cov;
param min_cov2;
#Number of categories
param N_cat;

#Set of cities
set Nodes := 0..N-1;
#Set of modes of transports -(1 - Airport, 2- Train, 3- Road)
set modes := 1..m;
#dummy set for identifying cost and time (1 is cost, 2 is time in hrs)
set dum := 1..2;
#Set of arcs
set Arcs:={i in Nodes, j in Nodes: i<>j};
#Set of city categories
set cat:= 1..N_cat;
set regions_set:= 1..4;

# Parameter of list of arcs available for TSP
param path{Nodes,modes,dum,Nodes};
# Parameter for hotel cost stay
param hotel_cost{Nodes};
# Parameter for recommended days of stay
param min_days{Nodes};
# Parameter for daily cost
param daily_cost;
# Parameter for tourism expense
param tourism_exp{Nodes};
# Parameter for budget
param budget;
# Parameter for available time
param time;
# Parameter for category of city
param category{Nodes,cat};

#Parameter for regions
param region{Nodes,1..4};

param BigM:= N;

# Variable for arc chosen for TSP 
var x{Nodes,modes,Nodes} binary;
# Variable for time spent in city i
var time_stay{Nodes} >=0;
# Variable for total expense
var expense >=0;
# Variable for total time spent
var total_stay>=0;
# Variable for mode of transport identification
var mode_of_transport{Nodes,Nodes} >=0;

#Variable for rank
var rank{Nodes} integer >=0; #oposition of the node in the tour

#********************************* Objective function*************************
maximize Tourlength: sum{(i,j) in Arcs, k in modes} x[i,k,j];# Number of cities visited
subject to
# TSP constraints
common{i in Nodes, k in modes}:x[i,k,i]=0;# Cannot visit node i from node i
indegree_main: sum{(0,j) in Arcs, k in modes}x[0,k,j] = 1; # Indegree for node 0
indegree{j in Nodes}: sum{(i,j) in Arcs, k in modes}x[i,k,j] <= 1; # Indegree constraint
outdegree{i in Nodes}: sum{(i,j) in Arcs, k in modes}x[i,k,j] <= 1; # Outdegree constraint
in_equal_out{i in Nodes}: sum{j in Nodes, k in modes:i<>j} x[i,k,j]=sum{j in Nodes, k in modes:i<>j} x[j,k,i] ;# Indegree equals Outdegree constraint
stb{(i,j) in Arcs:j>0}: rank[j] >= rank[i] + 1 - BigM*(1- (sum{k in modes} x[i,k,j]));
stb2{(i,j) in Arcs:j>0}: rank[j] <=  rank[i] + 1 +BigM*(1-(sum{k in modes} x[i,k,j]));
stb3{j in Nodes}: rank[j] <=  BigM*((sum{i in Nodes,k in modes} x[i,k,j]));
stb1: rank[0] = 1;

# Minimum coverage constraints
minimum_coverage{c in cat}: sum{i in Nodes,j in Nodes, k in modes}x[i,k,j]*category[j,c]>=min_cov; #Minimum coverage
minimum_coverage2{r in regions_set}: sum{i in Nodes,j in Nodes, k in modes}x[i,k,j]*region[j,r]>=min_cov2; #Minimum coverage2


# Recomended days of stay
MIN_reco_stay_days{i in Nodes}: time_stay[i] = (sum{j in Nodes, k in modes:i<>j} x[j,k,i])*min_days[i];
time_constraint: (sum{i in Nodes}time_stay[i] + (sum{(i,j) in Arcs, k in modes}x[i,k,j]*path[i,k,2,j])/24)<= time;
total_stay_cont: total_stay=(sum{i in Nodes}time_stay[i] + (sum{(i,j) in Arcs, k in modes}x[i,k,j]*path[i,k,2,j])/24);

# Budget constraint
budget_constraint: (sum{i in Nodes}time_stay[i]*(hotel_cost[i]+daily_cost) + (sum{(i,j) in Arcs, k in modes}x[i,k,j]*path[i,k,1,j])  +  sum{(i,j) in Arcs, k in modes}x[i,k,j]*tourism_exp[j] )<= budget;
expenseconst: (sum{i in Nodes}time_stay[i]*(hotel_cost[i]+daily_cost) + sum{(i,j) in Arcs, k in modes}x[i,k,j]*path[i,k,1,j] + sum{(i,j) in Arcs, k in modes}x[i,k,j]*tourism_exp[j] ) = expense;

#Mode of transport
Mode_trans{(i,j) in Arcs}: mode_of_transport[i,j]  = sum{k in modes}k*x[i,k,j];
 
