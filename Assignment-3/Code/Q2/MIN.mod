#************** Parameters declaration ********


# No of mines in the area
param n_mines;
set Mines := 1..n_mines;

# No of years of simulation
param n_years;
set Years := 1..n_years;

# Maximum mines that can be used per year
param max_use;

#Revenue per ton
param rev;

#Discount factor
param r;

#Royalties paid for open mines
param royalties{Mines};


# Mine quality
param mine_qual{Mines};

# Minimum stipulated quality every year
param stip_qual{Years};

# Maximum mine extraction
param max_extract{Mines};


# Big M
param M:= max{m in Mines} max_extract[m];

#********* Variables declaration ***********#

# Mines_Open[i,j] = 1 if mine i is open in year j 
var Mines_Open{Mines,Years} binary;

# Mines_Use[i,j] = 1 if mine i used in year j 
var Mines_Use{Mines,Years} binary;

# Extract[i,j] amount of ore extracted from mine i in year j 
var Extract{Mines,Years} >=0;

# Revenue in year j
var Revenue{Years}>=0;

# Cost in year j
var Cost{Years}>=0;


# Cashflow in year j
var Cash_Flow{Years};


#************ Objective function ************#

maximize Profits: sum{y in Years} (Cash_Flow[y]/(1+r)^(y-1));



#************ Constraints ************#
subject to

# Overall objective funtion constraints
Cash_flow_const{y in Years}: Cash_Flow[y] = Revenue[y] - Cost[y];
Revenue_const{y in Years}: Revenue[y] =  sum{m in Mines} rev*Extract[m,y];
Cost_const{y in Years}: Cost[y] =  sum{m in Mines} royalties[m]*Mines_Open[m,y];


# Open-Use relationship constraint
Open_use_const{m in Mines, y in Years}: Mines_Use[m,y]<=Mines_Open[m,y];

# Open-precedence constraint
#Open_preced_const{m in Mines, y in Years:y>1}:Mines_Open[m,y]<=Mines_Open[m,y-1];
Open_preced_const{m in Mines, y in Years, k in Years:k<=y}: M*Mines_Open[m,k]>=Extract[m,y];

# Use-Extraction relationship constraint
Use_extract_const{m in Mines, y in Years}: M*Mines_Use[m,y]>=Extract[m,y];

# Stipulated Quality constraint
Quality_extract_const{y in Years}: sum{m in Mines}mine_qual[m]*Extract[m,y]=stip_qual[y]*(sum{m in Mines}Extract[m,y]);

# Maximum extraction
Max_extract_const{m in Mines, y in Years}:Extract[m,y]<=max_extract[m];

# Maximum mines use constraint
Max_use_const{y in Years}:sum{m in Mines} Mines_Use[m,y]<= max_use;









