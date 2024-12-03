# SYS 6003 Final Project, Fall 2024

# Sets
set evergreen; #Evergreen trees
set decid; #Deciduous trees
set nativedecid within decid;

# Parameters
param cost_i {evergreen}; # Cost of evergreen tree i
param cost_j {decid}; # Cost of evergreen tree j
param cr_i {evergreen}; # Quantity credit of evergreen tree i
param cr_j {decid}; # Quantity credit of evergreen tree j
param xir {evergreen}; # Quantity of evergreen trees i with root diameter of R20 or more
param yir {decid}; # Quantity of deciduous trees i with root diameter of R20 or more
param vi {evergreen}; # Annual carbon diozide absorption of evergreen tree i [kg/yr]
param vj {decid}; # Annual carbon diozide absorption of deciduous tree i [kg/yr]

param AA; # Area if the apartment complex [m^2]
param Ap; # Area of tree planting [m^2]
param a; # Coefficient of ratio of planting area to apartment complex area
param b; # Coefficient of minimum quantity of trees ratio to landscape area
param e; # Coefficient of evergreen trees ratio
param n; # Coefficient of native trees ratio
param Rccmax; # Max total canopy coverage ratio to landscape area
param Rccmin; # Min total canopy coverage ratio to landscape area
param CDA; # Total annual carbon dioxide absorption of planted trees [kg/yr]

# Variables
var xi {i in evergreen} integer >=0; # Evergreen tree quantity
var yi {j in decid} integer >=0; # Deciduous trees quantity

# Objective
minimize TotalCost:sum{i in evergreen} cost_i[i]*xi[i] + sum{j in decid} cost_j[j]*yi[j];

# Constraints
