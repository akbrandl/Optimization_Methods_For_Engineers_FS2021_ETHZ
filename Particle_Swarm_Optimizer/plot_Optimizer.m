% Function that runs and plots optimizer

clc; clear all; close;
format long; 

MOVIE = true; 
PLOT = true; 
MONARCHY = true;

CODE_SELECT_static = {'gx0','lr0','lw0','ln0','lx0'};
CODE_SELECT_dynamic = {'gx1','lr1','lw1','ln1','lx1'};

CODE_SELECT_topography = CODE_SELECT_static{1}; 

% Modify
dim = 2;
max_iter = (200*dim);
N = min(200,11*dim);

w   = 0.7; 
a1  = 1;
a2  = 2;

select_CASE = 4;
vel_rel = 0.3;

% Do not modify
fnc_in = @(x) test_functions_2D(x(1),x(2),select_CASE);
fnc = @(x,y) fnc_in([x,y]);

if select_CASE == 1         %% SHPERE
    fnc_select = 1;
    lb = [-10,-10]; ub = [10,10];
elseif select_CASE == 2     %% SINC
    fnc_select = 2;
    lb = [-5,-5]; ub = [5,5]; 
elseif select_CASE == 3     %% COS/SIN
    fnc_select = 3;
    lb = [-10,-10]; ub = [10,10];
elseif select_CASE == 4     %% BURKIN NR. 6
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

if ~MONARCHY
    [glob_best_F,glob_best_pos,store_F,store_position,iter,fnc_eval] = ...
        PSO_Plot(fnc_in,dim,max_iter,N,lb,ub,w,a1,a2,vel_rel,CODE_SELECT_topography); 
else 
    w   = [0.9,0.5];
    a1  = [3,0.1]; 
    a2  = [0.3,2];

    [glob_best_F,glob_best_pos,store_F,store_position,iter,fnc_eval] = ...
        PSO_Plot_Monarchy(fnc_in,dim,max_iter,N,lb,ub,w,a1,a2,vel_rel,CODE_SELECT_topography);
end

if PLOT
    if select_CASE == 10 || select_CASE == 11
        res = max(0.01, max(ub-lb)/200);
    elseif (select_CASE == 6) || (select_CASE == 4)
        res = max(0.1, max(ub-lb)/300);
    else
        res = max(0.05, max(ub-lb)/500);
    end
    fnc = @(x,y) test_functions_2D(x,y,select_CASE);

    x1 = lb(1):res:ub(1);
    x2 = lb(2):res:ub(2);

    [X1,X2] = meshgrid(x1,x2);

    plot_fnc = fnc(X1,X2);

    fig=figure('Color',[1 1 1]);

    for i = 1:iter
        clf; 
        if i == max_iter+1
            title(strcat('Iteration = ',{' '},num2str(i),...
                '       Best Fitness = ',{' '}, num2str(glob_best_F))); 
        else 
            title(strcat('Iteration = ',{' '},num2str(i),...
                '       Best Fitness = ',{' '}, num2str(store_F(i)))); 
        end

        hold on; 
           contourf(X1,X2,plot_fnc);
           colorbar; 
           for j = 1:N
               % j = Particle ID, i = iteration_step
               plot(store_position(i,1,j), store_position(i,2,j),'.k','MarkerSize',25);
           end
               plot(glob_best_pos(1),glob_best_pos(2),'x','MarkerEdgeColor',[192/255,0,0],'linewidth',4,'MarkerSize',10);
               grid on;
               xlabel('$x_1 \rightarrow$','fontweight','bold','Interpreter','latex');
               ylabel('$x_2 \rightarrow$','fontweight','bold','Interpreter','latex');
        hold off; 

        drawnow;
    end
end

if MOVIE
    make_movie
end