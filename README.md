# Optimization Methods For Engineers (FS2021, ETHZ)
Implementation of a particle swarm optimizer with different extensions such as: 
  1. static and dynamic/adaptive parameters, 
  2. various  population topologies, and 
  3. novel modification with intra-swarm hierarchical structure.


## 1. File Structuring
### 1.1. PSO-specific parameter (modifiable)
1. `fnc`, `fnc_select`:   function and function ID (1...11), respectively.
2. `dim`:   dimension of search space (recommended: 2)
3. `lb`, `ub`:   lower and upper bound of search space
4. `N`: number of particles in swarm
5. `max_iter`: maximum number of allowed iterations
6. `w`, `a1`, `a2`: hyperparameters/acceleration coefficients
7. `vel_rel`: maximum allowed velocity of particles
8. `CODE_SELECT`: encoding of PSO and swarm properties. 
    - 1st char (gPSO or lPSO?): \[g = global PSO; l = local PSO\]
    - 2nd char (Topology?): \[r = ring; w = wheel; n = von Neumann; x = random; f = full-mesh (gPSO)\]
    - 3d char  (Hyperparameter?): \[0 = static hyperparameter; 1 = adaptive/dynamic hyperparameter\]
    - *Example*: 'ln0' corresponds to local PSO (`l`) with static/constant hyperparameters (`0`) and von-Neumann swarm topology (`n`). 

### 1.2. Functions
1. `Particle.m`: class holding the properties and functions of object **Particle**.
2. `SwarmOptimizer_TB.m`: Simple PSO algorithm that finds optimum/minimum (`glob_best_F`, `glob_best_pos`) to objective function (`fnc`). Additionally, it returns the number of required iterations (`iter`), the total number of required fitness-function evaluations `fnc_eval`, and a message `message` that indicates if PSO ran successfully or not.  
3. `SwarmOptimizer_Monarchy.m`: Monarchy-based PSO algorithm that finds optimum/minimum (`glob_best_F`, `glob_best_pos`) to objective function (`fnc`), the number of required iterations (`iter`), the total number of required fitness-function evaluations `fnc_eval`, and a message `message` that indicates if PSO ran successfully or not. **Attention**: hyperparameters `w`, `a1` and `a2` are vectors with 2 elements as we have two classes of particles. 
4. `test_functions_2D.m`: selection of benchmark function. `x1` and `x2` correspond to the optimising parameter, and `CASE` corresponds to ID of selected benchmark (allowed values: 1...11). 
5. `StoppingCriteria.m`: function evaluating the stopping criterion. 
6. `get_Topology.m`: generates swarm topology and stores it in a cell array for efficient access.   
-> *Note*: to change the citerion, change 'type'-variable within function (if `type = 1` then PSO stops if no better solution found in a certain amount of iterations , and if `type = 2` then PSO stops if no significant improvement of solution detected).
7. `random_point.m`: generates random point in bounds `lb`, `up` with a resolution of 0.001. 


### 1.3. Testbench framework
1. `testbench.m`: 
2. `testbench_Monarchy.m`: 
3. `run_MATLAB.m`: function that solves optimization problem unsing the built-in MATLAB PSO algorithm and returns found optimum, number of evalutations and iterations, and the required CPU_time. 
4. 

### 1.4. Process and function visualization 
1. `plot_Optimizer.m`: Executes single PSO run with user-specified parameter such as hyperparameters (`w`, `a1` and `a2`), benchmark function `select_CASE` or swarm topology `CODE_SELECT_topography`. If `PLOT = true` then entire process is plotted, if `MOVIE = true` then PSO execution is stored as .avi-file, and if `MONARCHY = true` then monarachy-based PSO is executed instead of a standard PSO.<br/><br/>
Available PSO parameters: 
	- `w`, `a1` and `a2` are PSO hyperparameter,
	- `dim` defines search space dimension,
	- `select_CASE` defines benchmark function, 
	- `max_iter` defines maximum  number of allowed iterations,
	- `N` defines number of particles in swarm,
	- `CODE_SELECT_topography' defines the swarm topography, and
	- `vel_rel` defines maximum velocity of particles relative to search space. 
	
The following functions are only for debugging and parameter optimization. Each particle position is stored in each iteration - PSO algorithm execution can be then observed using the function `plot_Optimizer.m`. Do not use these functions for actual optimization problems - they are slow, memory intensive functions.    
i. `PSO_Plot.m`: function that executes simple PSO (see `SwarmOptimizer_TB.m`).     
ii. 'PSO_Plot_Monarchy.m': function that executes monarchy-based PSO (see `SwarmOptimizer_Monarchy.m`).

2. `plot_benchmarks.m`: plot available (2-dim) benchmark functions (values: 1..11)
3. `make_movie.m`: generates a video from the stored paramters and stores it as .avi-file

