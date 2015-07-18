function [ sol ] = Esolve_FISTA( Y, D, lambda )
%ESOLVE_FISTA   Solve for the error matrix.
%   Random comments.
    
    % Add helpers:
    temp{1} = mfilename('fullpath'); 
    temp{2} = strfind(temp{1}, mfilename);
    addpath([temp{1}(1 : (temp{2}(end))-1) 'helpers']);
    
    
    sol = mfilename;
end

