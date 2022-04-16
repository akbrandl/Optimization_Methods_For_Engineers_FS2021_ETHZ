function result = run_MATLAB(select_CASE,dim,N,max_iter,a1,a2, MATLAB_weights_default)
    %%% Implementation of MATLAB Particle Swarm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % (https://www.mathworks.com/help/gads/particleswarm.html)
    % Options of Interest:  'MaxIterations' (Default: 200*dim)  
    %                       'SelfAdjustmentWeight'...Cognitive term (Default: 1.49)
    %                       'SocialAdjustmentWeight'...Social term (Default: 1.49)
    %                       'SwarmSize'...N (Default: min(100,10*dim))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialize Function
        fnc_in = @(x) test_functions_2D(x(1),x(2),select_CASE); 

        % Initialize bounds (lower/upper) for search space
        if select_CASE == 1         %% SHPERE
            fnc_select = 1;
            lb = [-10,-10]; ub = [10,10];
        elseif select_CASE == 2     %% SINC
            fnc_select = 2;
            lb = [-5,-5]; ub = [5,5]; 
        elseif select_CASE == 3     %% COS/SIN
            fnc_select = 3;
            lb = [-10,-10]; ub = [10,10];
        elseif select_CASE == 4     %% BUKIN NR. 6
            fnc_select = 4;
            lb = [-15,-3]; ub = [-5,3];
        elseif select_CASE == 5     %% RASTRIGIN
            fnc_select = 5;
            lb = [-10,-10]; ub = [10,10];
        elseif select_CASE == 6     %% EGGHOLDER
            fnc_select = 6;
            lb = [-512,-512]; ub = [512,512];
        elseif select_CASE == 7     %% BOOTH    
            fnc_select = 7;
            lb = [-10,-10]; ub = [10,10];
        elseif select_CASE == 8     %% HÖLDER TABLE    
            fnc_select = 8;
            lb = [-10,-10]; ub = [10,10];
        elseif select_CASE == 9     %% SCHAFFER NR. 2
            fnc_select = 9;
            lb = [-100,-100]; ub = [100,100];
        elseif select_CASE == 10     %% Michalewicz (smooth; m=1)
            fnc_select = 10;
            lb = [0,0]; ub = [pi,pi];
        elseif select_CASE == 11    %% Michalewicz (steep; m=10)
            fnc_select = 11;
            lb = [0,0]; ub = [pi,pi];
        else
            fnc_select = -1;        %% ERROR
            lb = [-10,-10]; ub = [10,10];
        end
    
    if MATLAB_weights_default == 0          %% If default DISABLED, choose a1,a2 given by programmer
        options = optimoptions('particleswarm',...
            'MaxIterations',max_iter,...
            'SelfAdjustmentWeight', a1,...
            'SocialAdjustmentWeight', a2,...
            'SwarmSize',N);
    else %% If default ENABLED, choose DEFAULT a1,a2
        options = optimoptions('particleswarm',...
            'MaxIterations',max_iter,...
            'SwarmSize',N);
    end

    CPU_begin = cputime; 
        [x,fval,exitfalg,output] = particleswarm(fnc_in,dim,lb,ub,options); 
    CPU_PSO_MATLAB = cputime - CPU_begin; 

    % Store Data in Struct Array
    result_STRUCT.ID = cellstr('MATLAB');
    result_STRUCT.fnc = fnc_select; 
    result_STRUCT.max_Iteration = max_iter;
        % 1. Initialization
            result_STRUCT.SwarmSize = options.SwarmSize;
            result_STRUCT.interia = options.InertiaRange;
            result_STRUCT.cognitive = [options.SelfAdjustmentWeight,options.SelfAdjustmentWeight]; 
            result_STRUCT.social = [options.SocialAdjustmentWeight,options.SocialAdjustmentWeight]; 
        % 2. Results
            result_STRUCT.fval = fval; 
            result_STRUCT.pos = x;  
            result_STRUCT.fnc_eval = output.funccount;  % Number of objective function evaluations
            result_STRUCT.iterations = output.iterations; %	Number of solver iterations
            result_STRUCT.cpu_time = CPU_PSO_MATLAB; % Required Execution Time
    result = struct2table(result_STRUCT); 
end
