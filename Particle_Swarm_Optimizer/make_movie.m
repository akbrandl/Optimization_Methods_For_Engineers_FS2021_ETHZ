% Make Movie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code was partially adapted from the code provided by Prof. Jasmin Smajic  
% and Arif Güngör in the frame of the lecture "Fundamentals of Physical 
% Modeling and Simulations" (Spring 2021, ETH Zurich)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

frame_NUMBER=1;

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
for i =  1:iter
    clf; 
    if i == max_iter+1
        title(strcat('Iteration = ',{' '},num2str(i),...
            '       Best Fitness = ',{' '}, num2str(glob_best_F))); 
    else 
        title(strcat('Iteration = ',{' '},num2str(i),...
            '       Best Fitness = ',{' '}, num2str(store_F(i)))); 
    end
    
       meshc(X1,X2,plot_fnc);
        hold on; 
           for j = 1:N
               % j = Particle ID, i = iteration_step
               plot3(store_position(i,1,j), store_position(i,2,j),0,'.k','MarkerSize',25);
           end
               plot3(glob_best_pos(1),glob_best_pos(2),0,'x','MarkerEdgeColor',[192/255,0,0],'linewidth',4,'MarkerSize',10);
               grid on;
               xlabel('$x_1 \rightarrow$','fontweight','bold','Interpreter','latex');
               ylabel('$x_2 \rightarrow$','fontweight','bold','Interpreter','latex');
        hold off; 
    
%     hold on; 
%        contourf(X1,X2,plot_fnc);
%        colorbar; 
%        for j = 1:N
%            % j = Particle ID, i = iteration_step
%            plot(store_position(i,1,j), store_position(i,2,j),'.k','MarkerSize',25);
%        end
%            plot(glob_best_pos(1),glob_best_pos(2),'x','MarkerEdgeColor',[192/255,0,0],'linewidth',4,'MarkerSize',10);
% %                 plot(x(1),x(2),'.g','MarkerSize',30);
%            grid on;
%            xlabel('$x_1 \rightarrow$','fontweight','bold','Interpreter','latex');
%            ylabel('$x_2 \rightarrow$','fontweight','bold','Interpreter','latex');
%     hold off;
    
    drawnow;
    
    F(frame_NUMBER)=getframe(fig);
    frame_NUMBER=frame_NUMBER+1;
end

rate=10;
name = input('Name of recording: ','s');    % Asks for name 
writerObj = VideoWriter(strcat(name,'.avi'),'Motion JPEG AVI');
writerObj.FrameRate=rate;
open(writerObj);
writeVideo(writerObj,F);
close(writerObj);