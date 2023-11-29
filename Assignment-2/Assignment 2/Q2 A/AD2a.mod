param N_cities >0 integer;
param D_NDD >=0;
param N_FC >=0 integer;

set CITIES := 1..N_cities;
param Market {CITIES} >=0;
param Distance {CITIES,CITIES} >=0;

var X{CITIES} binary ; # Variable that indicates the presence of Facility center in city
var Y{CITIES,CITIES} binary; # 1 if city i is served by city j
var Dmax>=0;

minimize max_dist: Dmax;
subject to

Num_FC: sum{j in CITIES} X[j] = N_FC;
#X_Y_rel {j in CITIES}: sum{i in CITIES}Y[i,j]<=N_cities*X[j];
X_Y_rel {j in CITIES, i in CITIES}:Y[i,j]<=X[j];
X_Y_rel_2{j in CITIES}: X[j]<=sum{i in CITIES}Y[i,j];
Cover_all{i in CITIES}: sum{j in CITIES} Y[i,j]=1;
Dmax_cont{i in CITIES, j in CITIES}: Dmax>=Distance[i,j]*Y[i,j];