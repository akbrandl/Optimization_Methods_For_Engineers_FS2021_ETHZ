% Plot Benchmark Functions. 

select_CASE = 5;

if select_CASE == 1 
    lb = [-10,-10]; ub = [10,10];
    text = {'\textbf{Sphere Function}\vspace{0.1cm}','$F = x_1^2 + x_2^2$'};
    text = {'\textbf{Sphere Function}\vspace{0.1cm}'};
elseif select_CASE == 2  
    lb = [-5,-5]; ub = [5,5]; 
    text = {'\textbf{Sinc Function}','$F = -$sinc$(x_1^2 + x_2^2)$'};
    text = {'\textbf{Sinc Function}'};
elseif select_CASE == 3  
    lb = [-10,-10]; ub = [10,10];
    text = {'\textbf{Cos-Sin Function}','$F = \sin(x_1) + \cos(x_2)$'};
    text = {'\textbf{Cos-Sin Function}'};
elseif select_CASE == 4 
    lb = [-15,-3]; ub = [-5,3];
     text = {'\textbf{Bukin Function Nr. 6}','$F = 100\cdot\sqrt{|x_2-0.01\cdot(x_1^2)|} + 0.01\cdot|x1 + 10|$'};
     text = {'\textbf{Bukin Function Nr. 6}'};
elseif select_CASE == 5
    lb = [-10,-10]; ub = [10,10];
     text = {'\textbf{Rastrigin Function}','$F = 10\cdot 2+(x_1^2 - 10\cdot \cos(2\pi\cdot x_1))+ (x_2^2 - 10\cdot\cos(2\pi\cdot x_2))$'};
     text = {'\textbf{Rastrigin Function}'};
elseif select_CASE == 6  
    lb = [-512,-512]; ub = [512,512];
     text = {'\textbf{Eggholder Function}','$F = -(x_2+47)\cdot\sin\sqrt{\left|\frac{x_1}{2}+(x_2+47)\right|}- x_1\cdot\sin\sqrt{|x_1-(x_2+47)|}$'};
      text = {'\textbf{Eggholder Function}'};
elseif select_CASE == 7 
    lb = [-10,-10]; ub = [10,10];
     text = {'\textbf{Booth Function}','$F = (x_1 + 2\cdot x_2 - 7)^2 + (2\cdot x_1 + x_2 - 5)^2$'};
     text = {'\textbf{Booth Function}'};
elseif select_CASE == 8  
    lb = [-10,-10]; ub = [10,10];
     text = {'\textbf{Hoelder Table Function}','$F = -\left|\sin(x_1)\cdot\cos(x_2)\cdot\exp\left(\left|1-\frac{\sqrt{x_1^2+x_2^2}}{\pi}\right|\right)\right|$'};
     text = {'\textbf{Hoelder Table Function}'};
elseif select_CASE == 9
    lb = [-100,-100]; ub = [100,100];
    text = {'\textbf{Schaffer Function Nr. 2}','$F = 0.5 + \frac{\cos(\sin|x_1^2-x_2^2|)^2 - 0.5}{(1+0.001\cdot(x_1^2+x_2^2))^2}$'};
    text = {'\textbf{Schaffer Function Nr. 2}'};
elseif select_CASE == 10
    lb = [0,0]; ub = [pi,pi];
    text = {'\textbf{Michalewicz Function (smooth)}','$F = -\left(\sin(x_1)\cdot\sin^{2m}\left(\frac{1\cdot x_1^2}{\pi}\right) + \sin(x_2)\cdot\sin^{2m}\left(\frac{2\cdot x_2^2}{\pi}\right)\right),m=1$'};
    text = {'\textbf{Michalewicz Function (smooth)}'};
elseif select_CASE == 11
    lb = [0,0]; ub = [pi,pi];
    text = {'\textbf{Michalewicz Function (steep)}','$F = -\left(\sin(x_1)\cdot\sin^{2m}\left(\frac{1\cdot x_1^2}{\pi}\right) + \sin(x_2)\cdot\sin^{2m}\left(\frac{2\cdot x_2^2}{\pi}\right)\right),m=10$'};
     text = {'\textbf{Michalewicz Function (steep)}'};
end

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

f1 = figure;  
contourf(X1,X2,plot_fnc);  %% Plot contour & mesh in same plot
%title('Sphere Function'); 
title(text,'Interpreter','latex'); 
xlabel('$x_1$','fontweight','bold','fontsize',12,'Interpreter','latex');
ylabel('$x_2$','fontweight','bold','fontsize',12,'Interpreter','latex');
zlabel('$F$','fontweight','bold','fontsize',12,'Interpreter','latex');
