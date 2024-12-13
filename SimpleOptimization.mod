set Evergreen;
set Deciduous;


# Set related params
param cost { Evergreen union Deciduous };

# credit aligns with the cr_i and cr_j parameters in the paper.
# Since it's just a key -> value lookup it doesn't need to separate desiduous and evergreen
param credit { Evergreen union Deciduous };

param crown_coverage { Evergreen union Deciduous };

param co2_absorption { Evergreen union Deciduous };

# The paper uses a matrix to determine this but it was simpler to create a boolean map here
param is_native { Evergreen union Deciduous };

# Whether or not the root diameter is >= 20 cm (precomputed to a boolean, 1 = yes 0 = no)
param is_large_tree { Evergreen union Deciduous };


# Standalone params
param A_A > 0;
param A_L > 0;
param A_P > 0;

# m is the minimum percent of each tree that must be included for diversificiation.  Here we use 2%
param m := 0.02;

# a is amount expected to be planted, in this case 50%
param a := .2;

# the coefficient of minimum quantity of trees ratio to landscape area
param b;

# e is the coefficient of evergreen trees ratio, in this case 20%
param e := .2;

# v is the coefficient of native trees, using 10%
param v := .1;

# r is the ratio of large trees, using 10%
param r := .1;

# Range used in scenario 1
# minimum and maximum canopy coverage, respectively.  In this case 40% - 60% coverage acceptable
param R_min := .4;
param R_max := .6;

# TODO: Maybe find an evidence based value for this - goal that can change
# CDA is the total annual carbon dioxide absorption of planted trees (kg/year)
# Completely arbitrary value with no real meaning right now
# This is a cool value to play with that demonstrates shadow prices / sensitivity analysis
# Zelkova_serrata has a great C02 absorption:cost ratio, so increasing this constraint increases the count
param CDA := 1000;

# Variables
var x { Evergreen } integer >= 0;
var y { Deciduous } integer >= 0;


# Objective Function
minimize TotalCost:
	sum { i in Evergreen } x[i] * cost[i] +
	sum { j in Deciduous } y[j] * cost[j];
	
	
# Constraints

# NOTE: the number in Constraint (n) refers to the constraint reference in the original paper, 
# not sequential constraints defined in the ampl file.

# Constraint (4) indicates the ratio of planting area to the area of the apartment complex
# This seems more like an input validation constraint.  It is not required for solving,
# but ensures that the minimum tree coverage meets the coverage threshold of total land
subject to Minimum_Tree_Planting_Area_Meets_Ratio:
	A_P >= A_A * a;

# Constraint (5) denotes the minimum num- ber of trees per square meter for the total landscape area
# The sum of credits for Evergreen and Deciduous trees meets minimum number of trees per square meter
# b is the coefficient to scale down A_L. It is not defined in the paper, b = 0.1 is used here
subject to Total_Tree_Coverage_Meets_Coverage_Threshold:
	sum { i in Evergreen } x[i] * credit[i] +
	sum { j in Deciduous } y[j] * credit[j]
	>= (b * A_L);


# Constraint (6) defines the minimum ratio of evergreen trees to all trees
subject to Minimum_Evergreen_Coverage_Met:
	sum { i in Evergreen } x[i] * credit[i] >= e * (
		sum { i in Evergreen } x[i] * credit[i] +
		sum { j in Deciduous } y[j] * credit[j]
		);

# Constraint (7) defines the minimum number of native trees
# The paper makes the assumption that all native trees are deciduous,
# but for completeness I included both in this check.  
subject to Minimum_Native_Coverage_Met:
	sum { i in Evergreen } x[i] * is_native[i] * credit[i] +
	sum { j in Deciduous } y[j] * is_native[j] * credit[j] >= v * (
		sum { i in Evergreen } x[i] * credit[i] +
		sum { j in Deciduous } y[j] * credit[j]
		);

# Constraint (8) imposes the ratio of large trees among all trees
subject to Minimum_Ratio_Of_Large_Trees_Met:
	sum { i in Evergreen } ( x[i] * is_large_tree[i] ) + 
	sum { j in Deciduous } ( y[j] * is_large_tree[j] ) >= 
	r * sum { i in Evergreen } x[i] + sum { j in Deciduous } y[j];

# Constraints (9–10) specify the minimum and maximum values of the canopy coverage area ratio 
# of the entire tree to the landscape area, respectively

subject to Minimum_Canopy_Coverage_Is_Met:
	sum { i in Evergreen } x[i] * crown_coverage[i] +
	sum { j in Deciduous } y[j] * crown_coverage[j] >= R_min * A_L;

subject to Maximum_Canopy_Coverage_Is_Met:
	sum { i in Evergreen } x[i] * crown_coverage[i] +
	sum { j in Deciduous } y[j] * crown_coverage[j] <= R_max * A_L;
	
# Constraint (11) imposes the minimum standard for carbon dioxide absorption of all planted trees
subject to Minimum_CO2_Absorption_Level_Met:
	sum { i in Evergreen } x[i] * co2_absorption[i] +
	sum { j in Deciduous } y[j] * co2_absorption[j] >= CDA;

# Constraints (12) are required for the minimum ratio of the number of trees to the total tree quantity
# Basically diversification

subject to Diversification_Minimum_Met_Evergreen { t in Evergreen }:
	x[t] >= m * ( sum { i in Evergreen } x[i] + sum { j in Deciduous } y[j] );
	
subject to Diversification_Minimum_Met_Deciduous { t in Deciduous }:
	y[t] >= m * ( sum { i in Evergreen } x[i] + sum { j in Deciduous } y[j] );
	
