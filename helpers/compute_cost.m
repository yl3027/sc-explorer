function [ out ] = compute_cost(Y, D, E, lambda)
%COMPUTE_COST   Compute the cost for the SSC? problem.
    out = norm((Y-E)*D, 'fro')^2/2 + lambda * sum(abs(D(:)));
end

