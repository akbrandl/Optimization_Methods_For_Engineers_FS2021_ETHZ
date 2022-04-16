function f = test_functions_2D(x1,x2,CASE)
%   CASE = 1:   SPHERE FUNCTION                                                
%           ... one global Maximum (only use to test if algorithm actually 
%           can find an optimum - computationally not exhaustive)
%           Recommended D_S: -

%   CASE = 2: SINC FUNCTION
%           ... ONE global maximum, and multiple local maxima symmetrical 
%           around a point.
%           Recommended D_S: -3 <= x1,x2 <= 3

%   CASE = 3: COS-SIN FUNCTION
%           ... Periodically Repeating global Maximas (Multiple Equivalent
%           Solutions)
%           Recommended D_S: x1 < -8 & x1 < 5

%   CASE = 4: BUKIN FUNCTION NR. 6
%           ... Accumulation of local maximas close to each other, but only
%           ONE global maximum at (-10,1)
%           Recommended D_S: -15 <= x1 <= -5, -3 <= x2 <= 3

%   CASE = 5:   RASTRIGIN FUNCTION
%           ... large number ofmaximum local minim/maxima very close to each other
%           with a global  at (0,0)
%           Recommended D_S: -5 <= x1,x2 <= 5

%   CASE = 6:   EGGHOLDER FUNCTION
%           ... Many close local minima with global maximum at
%           (512,404.2319)
%           Recommended D_S: -512 <= x1,x2 <= 512

    switch CASE
        case 1 
            f = x1.^2 + x2.^2; 
            
        case 2
            f = -sinc(x1.^2 + x2.^2);

        case 3
            f = sin(x1)+cos(x2);
            
        case 4
            f = 100.*sqrt(abs(x2-0.01.*(x1.^2)))+0.01.*abs(x1+10);

        case 5  
            f = 10.*2+(x1.^2 - 10.*cos(2.*pi.*x1))+...
                    (x2.^2 - 10.*cos(2.*pi.*x2));
           
        case 6 
            f = -(x2+47).*sin(sqrt(abs((x1./2)+(x2+47))))-...
                    x1.*sin(sqrt(abs(x1-(x2+47))));
        
        % Functions for testing of optimized parameter
        case 7  %% BOOTH FUNCTION (bounds = -10,10); f(1,3) = 0
            f = (x1 + 2.* x2 - 7).^2 + (2.*x1 + x2 - 5).^2;
          
        case 8  %% Hölder table function (bounds = -10,10); F_best = -19.2085 @ f(+- 8.05502, +- 9.66459)
            f = -abs(sin(x1).*cos(x2).*exp(abs(1-(sqrt(x1.^2+x2.^2)/pi))));
        
        case 9  %% Schaffer function Nr. 2; bounds= (-100,100); f(0,0)=0
            f = 0.5 + (cos(sin(abs(x1.^2-x2.^2))).^2 - 0.5)./((1+0.001.*(x1.^2+x2.^2)).^2);
            
        case 10 %% Michalewicz Function (smooth); bounds = (0,pi);  
            m = 1;     %% Defines Steepness
            f = -(sin(x1).*sin((1.*(x1.^2))/pi).^(2.*m) + sin(x2).*sin((2.*(x2.^2))/pi).^(2.*m));
            
        case 11 %% Michalewicz Function (steep); bounds = (0,pi);  
            m = 10;     %% Defines Steepness
            f = -(sin(x1).*sin((1.*(x1.^2))/pi).^(2.*m) + sin(x2).*sin((2.*(x2.^2))/pi).^(2.*m));
    end
end

