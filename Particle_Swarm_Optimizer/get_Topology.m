% Stores swarm social structure/topology in cell array. Each row stores i the
% connected neigbors of particle i. 
function topology = get_Topology(N,type,PLOT)
    % f = fullmesh; r = ring; w = wheel; n = von neumann; x = random
    topology = cell(1,N); 
    
    if N == 1
        error(strcat('N = ',num2str(N),' is not allowed...')); 
    elseif N == 2
        topology{1} = 2; topology{2} = 1; 
    else
        if isequal(type, 'r')
            for i = 1:N
                topology{i} = [mod(i,N)+1, N - mod(1-i,N)]; 
                    % mod(i,N)+1 ... Predecessor 
                    % N - mod(1-i,N) ... Successor
            end
        elseif isequal(type, 'w')   
            % All particles are connected to the same node - particle 1
            for i = 1:N
                topology{i} = 1; 
            end
            topology{1} = 2:1:N; 
        elseif isequal(type, 'n')
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Find solution to: N = x*y+z       x = x_dim; y=y_dim;
            %                                   z = additinal nodes
            %    with conditions:   (1) z >= 0 (guaranteed by floor operation)
            %                       (2) x, y > 0 have comparable size (minimize
            %                       difference abs(x-y))
            
            % 1.1.  Generate vector with entries from 2 to N/2 (only N/2)
            %       because after N/2 the pattern for x*y repeates.
            if N == 3
                topology{1}=2; topology{2}=[1,3]; topology{3}=2; 
            else
                x = 2:1:floor(N/2); y = floor(N./x); 
            
                % 1.2.  Calculate z 
                z = N - x.*y; 
            
                % 1.3. Find indices for smalles values
                min_value_INDEX = find(z==min(z));  % All indices with min(z) as entry
                x = x(min_value_INDEX); y = y(min_value_INDEX); z = z(min_value_INDEX); 
                
                % 1.4. Find all entries where x & y are close to each other 
                % >> find smallest difference for equilibrium
                % 1.5. Find smallest value and select first appearing index (INDEX)

                [val,INDEX]=min(abs(x-y));
            
                % 1.6. Assign dimensions of Von-Neumann grid
                x_dim = x(INDEX); y_dim = y(INDEX); z = z(INDEX); 
            
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % 2. Assign (each particle has at most 4 neighbors)
                for i = 1:N-z 
                    topology{i} = [];

                    % Left Neighbor
                    % >> NOT on left boundary
                    if ~(mod(i-1,x_dim) == 0 || (i-1)<= 0)
                        topology{i} = [topology{i},i-1]; 
                    end

                    % Right Neighbor
                    % >> NOT on right boundary
                    if ~(mod(i,x_dim) == 0) % determine right neighbor
                        topology{i} = [topology{i},i+1];
                    end

                    % Upper Neighbor
                    % >> NOT in {1,2,...x_dim}
                    if (i-x_dim)> 0
                       topology{i} = [topology{i},i-x_dim]; 
                    end

                    % Lower Neighbor
                    % >> NOT in {(y_dim*x_dim)+1,...,(y_dim*x_dim)}
                    if (i+x_dim) <= (N-z)
                        topology{i} = [topology{i},i+x_dim]; 
                    end   
                end

                % Treat last z-elements seperately and add connections to
                % neighbors if required
                for i = N-z+1:N
                    topology{i} = [];
                    if ~(mod(i-1,x_dim) == 0)
                        topology{i} = [topology{i},i-1]; 
                    end

                    % Right Neighbor
                    % >> NOT on right boundary
                    if ~(mod(i,x_dim) == 0 || (i+1)>N) % determine right neighbor
                        topology{i} = [topology{i},i+1];
                    end

                    % Upper Neighbor
                    % >> NOT in {1,2,...x_dim}
                    if (i-x_dim)> 0
                       topology{i} = [topology{i},i-x_dim]; 
                       topology{i-x_dim} = [topology{i-x_dim},i]; % Don't forget to assign the new neighbor!!
                    end
                end
            end   
            
        elseif isequal(type, 'x')
            % 1. Generate symmetric matrix where each node is at least
            % connected to ONE other neighbor!
            A_random = randi([0 1], N,N).*~eye([N N]);  % Zero-Diagonal, we don't want a particle to be connected with itself
            A_diag = tril(A_random) + triu(A_random',1);
            
            for i = 1:size(A_diag,2)
                if ~any(A_diag(:,i))
                    num_Connections = randperm(N-1,1);      
                    allowed_index = setdiff(1:N,i);      
                    selected_INDEX = allowed_index(randperm(N-1,num_Connections));
                  
                    connection_NEW = zeros(N,1); 
                    connection_NEW(selected_INDEX) = 1;  
                    
                    A_diag(:,i) = A_diag(:,i) + connection_NEW; 
                    A_diag(i,:) = A_diag(i,:)+ connection_NEW'; 
                end
            end
            
            % 2. Set neighbors based on the symmetric matrix found
            for i = 1:N
                topology{i} = find(A_diag(i,:)==1);
            end
            
        else % f as default configuration
            for i = 1:N
                topology{i} = setdiff(1:N,i); 
            end
        end
    end
    
    if PLOT 
        A = zeros(N,N);
        for i = 1:N
            for k = 1:size(topology{i},2)
                A(i,topology{i}(k))=1; 
            end
        end
        G=graph(A); 
        figure('Name','Swarm Topology','NumberTitle','off'); 
            h = plot(G);
            h.NodeColor = [0,0,150]./255; h.MarkerSize = 20; h.Marker = '.';
            h.EdgeColor = [24,134,255]./255; h.LineStyle = '-'; h.LineWidth = 1.5;
            h.EdgeAlpha = 0.3;
            if isequal(type,'f')        text = ' (fullmesh)';   
            elseif isequal(type,'r')    text = ' (ring)';   
            elseif isequal(type,'w')    text = ' (wheel)';
            elseif isequal(type,'n')    text = ' (von Neumann)';
            else text = ' (random)'; end
            
            title(strcat('Social Connectivity',text));
    end
end
