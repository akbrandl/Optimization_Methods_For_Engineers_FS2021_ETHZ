classdef Particle < handle
    properties  
        %% Individual Properties
        % Current Particle's Characteristics at time t 
        % >> Where am I currently?
        pos; velocity;      % x(t) and v(t)
        fitness;            % F(t)
        
        % Particle's Memory 
        % >> What was my best?
        pos_best; fitness_best; % x_best_m and F_best_m 
        
                
        %% Global (swarm-specific) properties
        % Boundaries as const. Properties
        lb_pos; ub_pos; 
        lb_vel; ub_vel;
        
        % Each Particle Stores Fitness-Function Handle
        fnc;
    end
    
    methods
      %% CONSTRUCTOR - Initialization of Object
      function obj = Particle(fnc_in,lb_POSITION,ub_POSITION,...
              lb_VELOCITY,ub_VELOCITY)
          
          obj.fnc = fnc_in;
          
          % obj.pos = random_point(lb_POSITION,ub_POSITION);
          obj.pos = random_point(lb_POSITION,ub_POSITION);
          obj.velocity = random_point(lb_VELOCITY,ub_VELOCITY); 
          
          obj.fitness = obj.fnc(obj.pos); 
          
          obj.pos_best = obj.pos; 
          obj.fitness_best = obj.fitness;   
          
          % Initialize boundaries (lb = lower bound; ub = upper bound)
          % >> VELOCITY CLAMPING (bound velocities to certain value)
          obj.lb_pos = lb_POSITION; obj.ub_pos = ub_POSITION; 
          obj.lb_vel = lb_VELOCITY; obj.ub_vel = ub_VELOCITY;
      end
      
      
      %% UPDATE FITNESS OF PARTICLE
      function obj = update_FITNESS(obj)
          obj.fitness = obj.fnc(obj.pos);
          
          if obj.fitness < obj.fitness_best
              obj.fitness_best = obj.fitness; 
              obj.pos_best = obj.pos; 
          end
      end
      
      %% UPDATE VELOCITY OF PARTICLE
      function obj = update_velocity(obj,w,a1,a2,glob_Best)
          %    1. Define individual weighting factor 
          R_ind = rand(1, size(obj.velocity,2));
          R_grp = rand(1, size(obj.velocity,2));
          
          %    2. Calculate partial values 
          inertia = w .* obj.velocity;
          cognitive = a1 .* R_ind .* (obj.pos_best - obj.pos);
          social = a2 .* R_grp .* (glob_Best - obj.pos);
          
          %    3. New (proposed/calculated) value 
          v_new = inertia + cognitive + social;
          
          %    4. Velocity Clamping 
          obj.velocity = min(max(v_new,obj.lb_vel),obj.ub_vel); 
      end
      
      
      %% UPDATE POSITION OF PARTICLE
      %  >> Prerequirement: update_velocity executed for current iteration!
      function obj = update_position(obj)
          %    1. Calculate new position
          pos_new = obj.pos + obj.velocity; 
          
          obj.pos = min(max(obj.lb_pos,pos_new),obj.ub_pos);    % Set new position at boundaries, if new position does not lie within domain
          bool_direction = (obj.pos == pos_new);    % Check if point lies outside of domain and invert velocitiy if this is the case
          obj.velocity = (double(bool_direction)- ...
              double(~(bool_direction))).*obj.velocity; % move in other direction in next iteration
          
          % Adjust position at boundary. Iterates over each element and
          % checks if boundary condition holds -> Ajusts if not.
%           for i = 1:size(pos_new,2)
%               if pos_new(i) < obj.lb_pos(i)
% %                   pos_new(i) = obj.lb_pos(i);                 % Bouncing
% %                   obj.velocity(i) = (-1).*obj.velocity(i);
%                   pos_new(i) = obj.ub_pos(i) - abs(obj.lb_pos(i) - pos_new(i)); % Wrap-Around
%               elseif pos_new(i) > obj.ub_pos(i)
% %                   pos_new(i) = obj.ub_pos(i);                 % Bouncing
% %                   obj.velocity(i) = (-1).*obj.velocity(i);
%                   pos_new(i) = obj.lb_pos(i) + abs(pos_new(i) - obj.ub_pos(i)); % Warp-Around
%               end
%           end
%           
%           obj.pos = pos_new;  
      end
      
    end
end