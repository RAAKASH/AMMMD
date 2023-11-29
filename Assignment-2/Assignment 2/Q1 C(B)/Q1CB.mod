param N; # Number of Cities

set CITY:=1..N;

param p; #Maximum number of FC's planned to be opened

param travel_cost{CITY,CITY};  #cost of travelling from city f to city c

param demand{CITY}; #demand at city c

var X{CITY} >=0, <=1; # = 1 if an FC is opened at city f

var Y{CITY,CITY} >=0, <=1; # = 1 if FC at city f is catering to city c

minimize total_travel_cost: sum{f in CITY, c in CITY}demand[c]*travel_cost[f,c]*Y[f,c];

subject to

fulfillment_centers_requirement: sum{f in CITY}X[f] = p;
coverage_constraint {c in CITY}: sum{f in CITY}Y[f,c] >= 1;
X_Y_link1 {f in CITY,c in CITY}: Y[f,c] <= X[f];
