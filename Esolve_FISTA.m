function [ sol ] = Esolve_FISTA( Y, D, lambda )
%ESOLVE_FISTA   Solve for the error matrix.
%   Random comments.
    
    %% Add helpers:
    temp{1} = mfilename('fullpath'); 
    temp{2} = strfind(temp{1}, mfilename);
    addpath([temp{1}(1 : (temp{2}(end))-1) 'helpers']);

    %% Parameters:
    LIPC = 2*eigs(D'*D, 1 ,'lm');
    MAXIT = 1e4;
    EPSILON = 1e-8;
    
    %% Initialize:
    dn = size(Y);
    cost = @(E) compute_cost(Y,D,E,lambda);
    Xminus = zeros(dn); 
    W = Xminus;
    t = 1;
    
    %% Update:
    doagain = true; it = 0;
    DTD = D'*D;
    while doagain
        X = soft( W - (2/LIPC) * (W-Y) * DTD , lambda/LIPC );
        tplus = (1 + sqrt(1 + 4*t^2))/2;
        W = X + (t - 1)/tplus *(X - Xminus);
        
        it = it + 1;
        delta = abs(cost(Xminus) - cost(X));
        converge = delta <= EPSILON;
        doagain = (it < MAXIT) && ~converge;
        
        Xminus = X;
        t = tplus;
    end
    
    %% Return results:
    sol.E = X;
    sol.converge = converge;
    sol.delta = delta;
    sol.iters = it;
end

