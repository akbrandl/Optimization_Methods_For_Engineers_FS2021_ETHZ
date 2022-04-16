function result = testbench(fnc,dim,lb,ub,N,max_iter,w,a1,a2,vel_rel,...
    fnc_select,CODE_SELECT)
% testbench(fnc,dim,lb,ub,N,max_iter,w,a1,a2,main_message)
%      Checks Performance of an Optimization Algorithm
%      => no plotting option
% 
% Input:    N...Number of Particles
%           max_iter...Max. Number of allowed iterations
%           fnc...[Type: f=@(x)...] Objective Function (Function Handle)
%           dim...Number of variables (a.k.a nvars)
%           lb/ub...lower/upper bound of search space Ds
%           main_message...message from main to identify problem set later
%           a1...Cognitive Term;    a2...Social Term
%
% Options:      1. global best PSO (full-mesh config)
%               2. local best PSO:  2.1. ring config ('r')
%                                   2.2. wheel config ('w')
%                                   2.3. von neumann config ('n')
%                                   2.4. random config ('x')
%                                   (2.0. full-mesh ('f') => redundant topolgy initialization 
%                                                           + memory-read operations) <=> use gPSO)
%               3. Enable/Disable Simulated Annealing
%
%               Code: {1: g,l}{2: 0,1}{3:r,w,n,rand,f}
%                       1 = global/Local; 2 = SA on(1)/off(0); 3 = topology
%
% Evaluation Criterions:    
%           1. Correctness 
%           2. Execution Time (CPU Ressources) [x=cputime], 
%           3. Used Memory Ressource 
%                   [user1,sys1] = memory; % memory information @program start
%                       %% Execute Program
%                   [user2,sys2] = memory; % MEM@End
%                   memory_used_in_Bytes = user2.MemAvailableAllArrays-user.MemAvailableAllArrays;
%
%
% Paramters:    1. Variation of #of particles
%               2. Variation of objective function

    %% Implementation of own PSO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     CODE_SELECT = {'gx0','lr0','lw0','ln0','lx0','gx1','lr1','lw1','ln1','lx1'};
    count = numel(CODE_SELECT);             %Count number of elements in list
        
%     if (count ~= numel(w)) || (count ~= numel(a1)) || (count ~= numel(a2))
%         % Argument error - do not through error as entire execution would
%         % fail (testbench would stop). Indicate error and continoue!
%         result_STRUCT(2).ID = 'ERROR'; 
%         result = struct2table(result_STRUCT); 
%         return; 
%     end
    
    for i = 1:count
        code_select_i = char(CODE_SELECT(i)); 

        CPU_begin = cputime; 
        [fval,x,iter,fnc_eval,message] = ...
            SwarmOptimizer_TB(fnc,dim,max_iter,N,lb,ub,w,a1,a2,vel_rel,code_select_i); 
        CPU_PSO_own = cputime - CPU_begin;

        if isequal(code_select_i(1),'g') || isequal(code_select_i(2),'f')
%             result_STRUCT(i+1).ID = strcat('gPSO_','N=',num2str(N));
            result_STRUCT(i).ID = 'gPSO';
        else 
%             result_STRUCT(i+1).ID = strcat('lPSO_',char(CODE_SELECT(i)),'_N=',num2str(N));
            result_STRUCT(i).ID = strcat('lPSO_',code_select_i);
        end
        result_STRUCT(i).fnc = fnc_select; 
        result_STRUCT(i).max_Iteration = max_iter;
            % 1. Initialization
                result_STRUCT(i).SwarmSize = N;
                if isequal(code_select_i(end),'1')
                    result_STRUCT(i).interia = [0.4,0.9];
                    result_STRUCT(i).cognitive = [0.5,2.5]; 
                    result_STRUCT(i).social = [0.5,2.5]; 
                else
                    result_STRUCT(i).interia = [w,w];
                    result_STRUCT(i).cognitive = [a1,a1]; 
                    result_STRUCT(i).social = [a2,a2]; 
                end
            % 2. Results
                result_STRUCT(i).fval = fval; 
                result_STRUCT(i).pos = x;  
                result_STRUCT(i).fnc_eval = fnc_eval;  % Number of objective function evaluations
                result_STRUCT(i).iterations = iter; %	Number of solver iterations
                result_STRUCT(i).cpu_time = CPU_PSO_own; % Required Execution Time
    end
    % ISSUE: the first program execution is slower than following
    % executions (how to fix it??? Running it multiple times does not really solve....)
    %% Convert Struct to readable table
    
    result = struct2table(result_STRUCT); 
end

