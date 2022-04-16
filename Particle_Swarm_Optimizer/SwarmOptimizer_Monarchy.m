function [glob_best_F,glob_best_pos,iter,fnc_eval,message] = SwarmOptimizer_Monarchy(...
    fnc,dim,max_iter,N,lb,ub,w_in,a1_in,a2_in,vel_rel,CODE_SELECT)
%% Paramteter Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default Initialization
glob_best_F = inf;      glob_best_pos = NaN(1,dim); 
iter = 0;               fnc_eval = 0; 

topology_Plot = false;   

max_step_size = (ub-lb).*vel_rel; %% vel_rel selected by user
   ub_velocity = max_step_size;     
   lb_velocity = -ub_velocity;                     
   
%% Monarch to Worker Ration
    ratio = 0.3;    %% Let at firt 30% of all particles be selfish monarchs
    N_particles = 1:1:N; 
    
    N_monarch = datasample(N_particles,floor(N*ratio));     %% Random Selection of ruler
    N_worker = setdiff(N_particles,N_monarch);            %% Remaining particles = worker
    
    w = zeros(1,N); a1 = zeros(1,N); a2 = zeros(1,N);
    
    % Assign monarch & worker hyperparameter to each particle  
    w(N_monarch) = w_in(1); a1(N_monarch) = a1_in(1);   a2(N_monarch) = a2_in(1);     % Egoistic - high a1, low a2
    w(N_worker) = w_in(2);  a1(N_worker) = a1_in(2);    a2(N_worker) = a2_in(2);      % Trustful - low a1, high a2
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
            
            
            swarm(i).update_velocity(w(i),a1(i),a2(i),pos__best_neighbor);
        end
        
        for i = 1:N
            % 3. Update positions & fitness AFTER ALL particle updated 
            %    their velocity
            swarm(i).update_position;
            
            swarm(i).update_FITNESS;
            fnc_eval = fnc_eval + 1;
        end
    end
    
    message = 1;
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
            swarm(i).update_velocity(w(i),a1(i),a2(i),glob_best_pos);
            swarm(i).update_position;
            
            swarm(i).update_FITNESS;
            fnc_eval = fnc_eval + 1; 
        end
    end
    message = 1;
else 
    % Don't run error as entire Matlab execution would stop!!! 
    % message = strcat('CODE_SELECT (',CODE_SELECT,') is invalid expression.');
    message = -1; 
end
end
