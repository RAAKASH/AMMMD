param N_cities >0 integer;
param D_NDD >=0;
param N_FC >=0 integer;

set CITIES := 1..N_cities;
param Market {CITIES} >=0;
param Distance {CITIES,CITIES} >=0;
param M:= max {i in CITIES, j in CITIES} Distance[i,j];
var X{CITIES} binary; # Variable that indicates the presence of Facility center in city
var Y{CITIES,CITIES} binary; # 1 if city i is served by city j
var D{CITIES} ; # Distance of the closest facility from city i


maximize max_dist: sum{i in CITIES} D[i];
subject to
Num_FC: sum{j in CITIES} X[j] = N_FC;
Cover_all{i in CITIES}: sum{j in CITIES} Y[i,j]=1;
X_Y_rel {j in CITIES, i in CITIES}:Y[i,j]<=X[j];
X_Y_rel_2{j in CITIES}: X[j]<=sum{i in CITIES}Y[i,j];
Dist{i in CITIES, j in CITIES}: D[i]<=  Distance[i,j]*X[j] + (1-X[j])*M 