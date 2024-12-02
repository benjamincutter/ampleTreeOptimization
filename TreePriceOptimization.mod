# SYS 6003 Final Project, Fall 2024

# Sets
set evergreen; #Evergreen trees
set decid; #Deciduous trees

# Parameters
param cost_i {i in evergreen};
param cost_j {j in decid};

# Variables
var x {i in evergreen} integer >=0; # Evergreen trees
var y {j in decid} integer >=0; # Deciduous trees

# Objective
minimize TotalCost:sum{i in evergreen} cost_i[i]*x[i] + sum{j in decid} cost_j[j]*y[j];

# Constraints
