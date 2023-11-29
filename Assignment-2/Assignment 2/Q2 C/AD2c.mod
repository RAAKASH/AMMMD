param N_cities >0 integer;
param D_NDD >=0;
param N_FC >=0 integer;

set CITIES := 1..N_cities;
param Market {CITIES} >=0;
param Distance {CITIES,CITIES} >=0;
param M:= max {i in CITIES, j in CITIES} Distance[i,j];
var X{CITIES} binary; # Variable that indicates the presence of Facility center in city
var D{CITIES} ; # Distance of the closest facility from city i


maximize max_dist: sum{i in CITIES} D[i];
subject to
Num_FC: sum{j in CITIES} X[j] = N_FC;
Dist{i in CITIES, j in CITIES}: D[i]<=  Distance[i,j]*X[j] + (1-X[j])*M 