###################################
# Parameters and sets
###################################

# Number of farms
param n;

# Number of nodes
param N = n+1;

# Truck capacity
param K;

#Set of nodes
set Nodes:= 1..N;

# Coordinates of farms (1 corresponds to the company location)
param X{Nodes};
param Y{Nodes};

# D = 1 if milk has to be picked up daily from the farm, o for alternate day pick-up
param D{Nodes};

# R = Quantity of milk to be picked up at once
param R{Nodes};

# Set of arcs
set Arcs := {i in Nodes, j in Nodes: i<>j};

# Lenght of arcs
param L{(i,j) in Arcs} := sqrt((X[i]-X[j])^2 + (Y[i]-Y[j])^2);

###################################
# Decision variables
###################################

var PR1{(i,j) in Arcs} binary;	# PR1ij = 1 if node j is visited directly from node i in route 1
var PR2{(i,j) in Arcs} binary;	# PR12ij = 1 if node j is visited directly from node i in route 2
var S1{Nodes} integer >= 0;			# S1i = sequence of nodes in route 1, 0 for nodes not included in route 1
var S2{Nodes} integer >= 0;			# S2i = sequence of nodes in route 1, 0 for nodes not included in route 1

###################################
# Objective
###################################

minimize Tourlength: sum{(i,j) in Arcs} L[i,j]*(PR1[i,j]+PR2[i,j]);
subject to

###################################
# Constraints
###################################

# Each node which has to be visited daily should be a part of route 1 and route 2
# and visited from only 1 node in each route
Indegree_Daily_Route1 {j in Nodes : D[j] = 1}: sum{i in Nodes: i<>j} PR1[i,j] = 1;
Indegree_Daily_Route2 {j in Nodes : D[j] = 1}: sum{i in Nodes: i<>j} PR2[i,j] = 1;

# Each node which has to be visited on alternate days should be a part either route 1 or route 2
# and visited from only 1 node in the respective route
Indegree_Alternate {j in Nodes : D[j] = 0}: sum{i in Nodes: i<>j} (PR1[i,j] + PR2[i,j]) = 1;

# Indegree = Outdegree
Flux_Route1 {j in Nodes}: sum{i in Nodes: i<>j} PR1[i,j] = sum{i in Nodes: i<>j} PR1[j,i];
Flux_Route2 {j in Nodes}: sum{i in Nodes: i<>j} PR2[i,j] = sum{i in Nodes: i<>j} PR2[j,i];

# Sequence of node 1 is 1 in both routes
Sequence_node_1_route1 : S1[1] = 1;
Sequence_node_1_route2 : S2[1] = 1;

# If a node j is visited from node i in a route, sequence of node j should be higher than that of node i
Sequence_Route1 {(i,j) in Arcs : j>1} : S1[j] >= S1[i] + 1 - (N + 1)*(1 - PR1[i,j]);
Sequence_Route2 {(i,j) in Arcs : j>1} : S2[j] >= S2[i] + 1 - (N + 1)*(1 - PR2[i,j]);

# Maximum value of sequence in a route = number of nodes included in the route
Sequence_max_route1 {j in Nodes}: S1[j] <= sum{(i,k) in Arcs} PR1[i,k];
Sequence_max_route2 {j in Nodes}: S2[j] <= sum{(i,k) in Arcs} PR2[i,k];

# Sequence of nodes not included in the route should be 0
Sequence_0_route1 {j in Nodes}: S1[j] <= N * (sum{i in Nodes: i<>j} PR1[i,j]);
Sequence_0_route2 {j in Nodes}: S2[j] <= N * (sum{i in Nodes: i<>j} PR2[i,j]);

# Collection requirement constraint
Collection_Requirement_Route1: sum{(i,j) in Arcs} PR1[i,j]*R[j] <= K;
Collection_Requirement_Route2: sum{(i,j) in Arcs} PR2[i,j]*R[j] <= K;
