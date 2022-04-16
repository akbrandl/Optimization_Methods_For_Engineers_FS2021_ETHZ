% In this stopping criteria, we just set the max. number of iterations
function bool = StoppingCriteria(iteration, max_iteration, F_max) %,N,swarm
%% StoppingCriteria
%       iteration...current iteration
%       max_iteration...maximum allowed number of iteration
%%
    bool = 0;   % Default Assignment
    
    % 1...fixed iteration; 2...no sign. improvement
    type = 2; 
    
    persistent f_count F_past e_threshold %% Persistent = variable that is only known to function but stored in memory. DON'T FORGET TO DELETE
    
    if iteration < max_iteration
        % 1. Maximum Iteration (iteration + max_iteration) -> NOT
        %    Instructions - default criterion
        bool = 1;
 
        % 2. Stagnation of improvement (max_iteration + current best +
        %    previous best + variable that stores the number of consectuive
        %    best until maximum is achieved + maximum number of same fitness)
        if type == 2
            if isempty(f_count) || isempty(F_past) || isempty(e_threshold)
                % Assumption always empty if function is called the first time
                f_count = 1;
                F_past = F_max;
                e_threshold = 15; 
            else
                f_count = f_count + 1;  % Increment f_count as default 
                
                if F_max < F_past       % If improvement, then...
                    
                    % if (F_past - F_max)>1E-20 %% Implementation of tolerance
                        f_count = 1;        %   1. Reset counter
                    % end
                    
                    F_past = F_max;     %   2. Update best fitness
                else
                    if f_count > e_threshold    % Terminate
                        bool = 0; 
                    end
                end
            end
        end
    end

    % ALWAYS delete persistent variables if PSO is finished!
    if ~bool 
        clear f_count F_past e_threshold
    end
end