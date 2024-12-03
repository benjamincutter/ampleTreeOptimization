# SYS 6003 Final Project, Fall 2024

# Sets
set evergreen; #Evergreen trees
set decid; #Deciduous trees
set nativedecid within decid;

# Parameters
param cp_i {evergreen}; # Crown projection area of evergreen tree i  [m^2]
param cp_j {decid}; # Crown projection area of deciduous tree j [m^2]
param cost_i {evergreen}; # Cost of evergreen tree i
param cost_j {decid}; # Cost of evergreen tree j
param cr_i {evergreen}; # Quantity credit of evergreen tree i
param cr_j {decid}; # Quantity credit of evergreen tree j
param xir {evergreen}; # Quantity of evergreen trees i with root diameter of R20 or more
param yir {decid}; # Quantity of deciduous trees i with root diameter of R20 or more
param vi {evergreen}; # Annual carbon diozide absorption of evergreen tree i [kg/yr]
param vj {decid}; # Annual carbon diozide absorption of deciduous tree i [kg/yr]

param wi; # Crown width of tree i [m]
param Rcc; # Total canopy coverage ratio to alndscape area
param AL; # Landscapre area of apartment complex [m^2]
param AA; # Area if the apartment complex [m^2]
param Ap; # Area of tree planting [m^2]
param a; # Coefficient of ratio of planting area to apartment complex area
param b; # Coefficient of minimum quantity of trees ratio to landscape area
param e; # Coefficient of evergreen trees ratio
param n; # Coefficient of native trees ratio
param Rccmax; # Max total canopy coverage ratio to landscape area
param Rccmin; # Min total canopy coverage ratio to landscape area
param CDA; # Total annual carbon dioxide absorption of planted trees [kg/yr]

param m; #IDK WHAT THIS IS????????????, minimum ratio perhaps??

# Variables
var xi {i in evergreen} integer >=0; # Evergreen tree quantity
var yj {j in decid} integer >=0; # Deciduous trees quantity

# Objective
minimize TotalCost:sum{i in evergreen} cost_i[i]*xi[i] + sum{j in decid} cost_j[j]*yj[j];

# Constraints
subject to CrownProj {i in evergreen}: cp_i[i] = ((wi[i]/2)^2)*pi; # Crown Projection Calc - eqn 1
subject to TotalCanopy: Rcc = (sum{i in evergreen} cp_i[i]*xi[i] + sum{j in decid} cp_j[j]*yj[j])*100/AL; # Rcc calc - eqn2
subject to AreaRatio: AP >=a*AA;  # Constraint 4
subject to MinTrees:sum{i in evergreen} cr_i[i]*xi[i] + sum{j in decid} cr_j[j]*yj[j] >= b*AL; # Constraint 5
subject to EvergreenRatio: sum{i in evergreen} cr_i[i]*xi[i] >= e*(sum{i in evergreen} cr_i[i]*xi[i] + sum{j in decid} cr_j[j]*yj[j]); # Constraint 6
subject to NativeMin: sum{j in nativedecid} cr_j[j]*yj[j] >= n*(sum{i in evergreen} cr_i[i] * xi[i] + sum{j in decid} cr_j[j] * yj[j]); # Constraint 7
subject to LargeTreeRatio: sum{i in evergreen} xir[i] + sum{j in decid} yjr[j] >= r*(sum{i in evergreen} xi[i] + sum{j in decid} yj[j]); # Constraint 8
subject to MaxCanopyCoverage: sum{i in evergreen} cp_i[i]*xi[i] + sum{j in decid} cp_i[j]*yj[j] <= Rccmax*AL; # Constraint 9
subject to MinCanopyCoverage: sum{i in evergreen} cp_i[i]*xi[i] + sum{j in decid} cp_i[j]*yj[j] >= Rccmin*AL; # Constraint 10
subject to CarbonAbsorb: sum{i in evergreen} vi[i]*xi[i] + sum{j in decid} vj[j]*yj[j]; # Constraint 11
subject to MinRatioEvergreen {i in evergreen}: xi{i] >= m*(sum{i in evergreen} xi[i] + sum(j in decid} yj[j]); # Constraint 12
subject to MinRatioDecid {j in decid}: yj[j] >= m*(sum{i in evergreen} xi[i] + sum(j in decid} yj[j]); # Constraint 12
