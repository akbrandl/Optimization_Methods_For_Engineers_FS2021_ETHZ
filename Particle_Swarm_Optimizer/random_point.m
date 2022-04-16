function [x_random] = random_point(lb,ub)
    res = 0.001; % Defines how many floating points 
    
    N = size(lb,2);     % Reads dimension of lb
    x_random = zeros(1,N); 
    
    scaler = 1/res; 
    for i = 1:N
        if (lb(i) == ub(i)) 
            x_random(i) = lb(i); 
        elseif (lb(i) > ub(i)) 
            error('Bound Error: Lower Bound larger that Upper Bound - Element: %d',i); 
        else
                x_random(i) = randsample((lb(i)*scaler):(ub(i)*scaler),1)/(scaler);
        end
    end
end