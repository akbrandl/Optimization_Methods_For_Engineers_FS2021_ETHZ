# Optimization Methods For Engineers (FS2021, ETHZ)
Implementation of a particle swarm optimizer with different extensions such as: 
  1. static and dynamic/adaptive parameters, 
  2. various  population topologies, and 
  3. novel modification with intra-swarm hierarchical structure.


## 1. File Structuring

### PSO-specific parameter (modifiable)
1. `fnc`, `fnc_select`:   function and function ID (1...11), respectively.
2. `dim`:   dimension of search space (recommended: 2)
3. `lb`, `ub`:   lower and upper bound of search space
4. `N`: number of particles in swarm
5. `max_iter`: maximum number of allowed iterations
6. `w`, `a1`, `a2`: hyperparameters/acceleration coefficients
7. `vel_rel`: maximum allowed velocity of particles
8. `CODE_SELECT`: encoding of PSO and swarm properties. 
    - 1st char (gPSO or lPSO): \[g = global PSO; l = local PSO\]
    - 2nd char (Topology): \[r = ring; w = wheel; n = von Neumann; x = random; f = full-mesh (gPSO)\]
    - 3d char  (Hyperparameter?): \[0 = static hyperparameter; 1 = adaptive/dynamic hyperparameter\]
    - *Example*: 'ln0' corresponds to local PSO (`l`) with static/constant hyperparameters (`0`) and von-Neumann swarm topology (`n`). 

### 1.1. Process and function visualization 
1. __plot_Optimizer.m__: Executes single PSO run with user-specified parameter such as hyperparameters (`w`, `a1` and `a2`), benchmark function `select_CASE` or swarm topology `CODE_SELECT_topography`. If `PLOT = true` then entire process is plotted, if `MOVIE = true` then PSO execution is stored as .avi-file, and if `MONARCHY = true` then monarachy-based PSO is executed instead of a standard PSO.

 

	select_CASE = (1..11): selects test function
	CODE_SELECT_topography... select connectivity of the different particles. 

plot_benchmarks.m 	# plots benchmark function

make_movie.m  		# generates a video from the stored paramters and stores it as .avi-file
