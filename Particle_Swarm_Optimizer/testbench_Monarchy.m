function result = testbench_Monarchy(fnc,dim,lb,ub,N,max_iter,w,a1,a2,...
    vel_rel,fnc_select,CODE_SELECT)
%% Implementation of own PSO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     CODE_SELECT = {'gx0','lr0','lw0','ln0','lx0'};
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
            SwarmOptimizer_Monarchy(fnc,dim,max_iter,N,lb,ub,w,a1,a2,vel_rel,code_select_i);
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
                result_STRUCT(i).interia = w;
                result_STRUCT(i).cognitive = a1; 
                result_STRUCT(i).social = a2; 
                
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

