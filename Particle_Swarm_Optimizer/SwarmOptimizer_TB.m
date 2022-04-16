function [glob_best_F,glob_best_pos,iter,fnc_eval,message] = SwarmOptimizer_TB(...
    fnc,dim,max_iter,N,lb,ub,w,a1,a2,vel_rel,CODE_SELECT)
% Function finds optimum/minimum (glob_best_F, glob_best_pos) to objective function (fnc)
%
% Input:    fnc...Function Handle
%           dim...Numberof unknown variables
%           max_iter... Max. number of allowed iterations
%           N...Number of Particles
%           lb,ub...lower/upper bound of search space
%           w...Intertia       a1...cognitive       a2...social
%  
%           CODE_SELECT... Encoding of selected swarm behaviour 
%           'g'=gPSO, 'l'=lPSO, 
%           'f'=fullmesh, 'r'=ring, 'w'=wheel, 'n'=von neumann, 'x'=random
%           (e.g.'lr' = local PSO with ring topology)
%
% Output:   glob_best_F... Best (found) fitness
%           glob_best_pos... Best position
%           iter... Number of required iterations
%           fnc_eval...Number of function evaluations

%% Paramteter Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default Initialization
glob_best_F = inf;      glob_best_pos = NaN(1,dim); 
iter = 0;               fnc_eval = 0; 

topology_Plot = false;   % Enable/Disable plotting of connectivity graph

% (Symmetrical) Bounds for Velocity
% >> For Large Domains, high velocity & for small low velocity
% >> Selected the max. "Step Size" as 10% of the total domain (trial & error)
max_step_size = (ub-lb).*vel_rel; %%0.1
%     ub_velocity = linspace(max_step_size,max_step_size,dim);        % Creates Vector with N times the same entry
   ub_velocity = max_step_size;        % Creates Vector with N times the same entry
   lb_velocity = -ub_velocity;                     % eg. dim = 3 : ub_velocity=[2,2,2]


%% Swarm Initialization (Generation of N particles) %%%%%%%%%%%%%%%%%%%%%%%
swarm = [];    

for i = 1:N     %% Generation of N particles & storage in vector 'swarm'
    newborn = Particle(fnc,lb,ub,lb_velocity,ub_velocity); 
    swarm = [swarm,newborn];
    
    % during particle initialization, fitness function is evaluated once.
    fnc_eval = fnc_eval + 1;    
end

%% Initialization of Swarm topology (if 'l' && NOT 'f' selected; otherwise gPSO)
if isequal(CODE_SELECT(1),'l') && ~isequal(CODE_SELECT(2),'f')
    topology = get_Topology(N,CODE_SELECT(2),topology_Plot); 
end

%% Starts Execution of PSO
if isequal(CODE_SELECT(1),'l') && ~isequal(CODE_SELECT(2),'f') %% Local PSO
    while StoppingCriteria(iter, max_iter,glob_best_F) 
        iter = iter + 1; 
        
        % Evaluate global and local best fitness for each particle 
        % Seperate Evaluation and update to avoid asymmetry (particle
        % should only consider values from t, and not already updated
        % values from t+1)
        for i = 1:N 
            % 1. Evaluate best evaluation at time t
            % >> Possible to put in same loop as the fitness of only on
            % particle (i) is changer per loop
            if swarm(i).fitness < glob_best_F
                glob_best_F = swarm(i).fitness;
                glob_best_pos = swarm(i).pos;
            end

            % 2. Update velocity of each particle t->t+1
            % The separation of the velocity & position updates allows that
            % each particle only consideres the values of other particles
            % at t, and not the already updated values (for t+1)
            get_neighbors = topology{i};    % gets ID from neighbors
            F_best_neighbor = inf;
            for t = 1:size(get_neighbors,2)
                if swarm(t).fitness_best < F_best_neighbor
                    pos__best_neighbor = swarm(t).pos_best; 
                    F_best_neighbor = swarm(t).fitness_best;
                end
            end
            
            % We can update the velocity already in this loop as the
            % fitness function is not newly evaluated. (Benefit: we can
            % store pos__best_neighbor for all particles in one variable 
            % => memory efficient)
            
            if isequal(CODE_SELECT(end),'1')    %% Implementation of Dynamic Adaption of Hyperparameter
                % w = (w_start - w_end)x((max_iter-iter)/max_iter) + w_end
                w = (0.9-0.4)*((max_iter - (iter - 1))/(max_iter)) + 0.4; 
                
                % a1 = (a1_end-a1_start)x(iter/max_iter) + a1_start 	(Decrease over time)
                %a1 = (0.5 - 2.5)*((max_iter - (iter - 1))/max_iter) + 2.5; 
                a1 = (0.5 - 2.5)*((iter-1)/(max_iter-1))+ 2.5;
                
                % a2 = (a2_start-a2_end)x(iter/max_iter) + a2_end       (Increase over time)
                % a2 = (2.5 - 0.5)*((max_iter - (iter - 1))/max_iter) + 0.5; 
                a2 = (2.5-0.5)*((iter-1)/(max_iter-1))+ 0.5;
            end
            
            swarm(i).update_velocity(w,a1,a2,pos__best_neighbor);
        end
        
        for i = 1:N
            % 3. Update positions & fitness AFTER ALL particle updated 
            %    their velocity
            swarm(i).update_position;
            
            swarm(i).update_FITNESS;
            fnc_eval = fnc_eval + 1;
        end
    end
    
    message = 'ok';
elseif isequal(CODE_SELECT(1),'g') || isequal(CODE_SELECT(2),'f')   %% Global PSO
    while StoppingCriteria(iter, max_iter,glob_best_F) 
        % TO DO: global optimizer
        iter = iter + 1;
        
        % 1. Evaluate best fitness at time t 
        for i = 1:N 
            if swarm(i).fitness < glob_best_F      % detection of improved fitness
                glob_best_F = swarm(i).fitness; 
                glob_best_pos = swarm(i).pos; 
            end
        end
        
        % 2. Update velocity, position and fitness for (t+1)
        % >> Attention: Each particle should only consider the global best
        % fitness at t (seperation of 1. and 2. required; no change during updating process allowed)
        for i = 1:N
            if isequal(CODE_SELECT(end),'1')    %% Implementation of Dynamic Adaption of Hyperparameter
                % w = (w_start - w_end)x((max_iter-iter)/max_iter) + w_end
                w = (0.9-0.4)*((max_iter - (iter - 1))/max_iter) + 0.4; 
                
                % a1 = (a1_end-a1_start)x(iter/max_iter) + a1_start 	(Decrease over time)
                a1 = (0.5 - 2.5)*((max_iter - (iter - 1))/max_iter) + 2.5; 
                
                % a2 = (a2_start-a2_end)x(iter/max_iter) + a2_end       (Increase over time)
                a2 = (2.5 - 0.5)*((max_iter - (iter - 1))/max_iter) + 0.5;
                
                %disp(strcat('P_',num2str(i),'_iter_',num2str(iter),'_',num2str(w),'_',num2str(a1),'_',num2str(a2)));
            end
            
            swarm(i).update_velocity(w,a1,a2,glob_best_pos);
            swarm(i).update_position;
            
            swarm(i).update_FITNESS;
            fnc_eval = fnc_eval + 1; 
        end
    end
    message = 'ok';
else 
    % Don't run error as entire Matlab execution would stop!!! 
    message = strcat('CODE_SELECT (',CODE_SELECT,') is invalid expression.');
end
end
