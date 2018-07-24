%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA101
% Project Title: Implementation of Real-Coded Genetic Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function y=Mutate(x,mu,VarMin,VarMax, pos)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    if pos < 0
        j=randsample(nVar,nmu);
        %display("Called the standard mutate function.");
    else
        j = pos;
        %display("Called the reactionary mutate function.");
    end
   
    sigma=0.3*(VarMax-VarMin);
    
    
    
    y=x;
    temp = x(j)+sigma*randn(size(j));
    y(j)=temp(1);
    
    y=max(y,VarMin);
    y=min(y,VarMax);

end