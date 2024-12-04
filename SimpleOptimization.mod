set Evergreen;
set Deciduous;


# Set related params
param cost { Evergreen union Deciduous };

param credit { Evergreen union Deciduous };

param crown_coverage { Evergreen union Deciduous };

param co2_absorption { Evergreen union Deciduous };


# Standalone params
param A_A > 0;
param A_L > 0;

# Ratios
param m;

# Variables
var x { Evergreen } integer >= 0;
var y { Deciduous } integer >= 0;


# Objective Function
minimize TotalCost:
	sum { i in Evergreen } x[i] * cost[i] +
	sum { j in Deciduous } y[j] * cost[j];
	
	
# Constraints
###### Trivial constraints to make it solvable, NOT part of final version #####
# this just says to pick the cheapest evergreen and deciduous tree
subject to At_Least_One_Evergreen:
	sum { i in Evergreen } x[i] >= 1;

subject to At_Least_One_Deciduous:
	sum { j in Deciduous } y[j] >= 1;
############################################################


# This seems more like an input validation constraint.  It is not required for solving,
# but ensures that the minimum tree coverage meets the coverage threshold of total land
subject to Minimum_Tree_Planting_Area_Meets_Ratio:
	A_L >= A_A * m;

# The sum of crown coverage for Evergreen and Deciduous trees meets minimum coverage requirement
subject to Total_Tree_Coverage_Meets_Coverage_Threshold:
	sum { i in Evergreen } x[i] * crown_coverage[i] +
	sum { j in Deciduous } y[j] * crown_coverage[j]
	>= A_L;