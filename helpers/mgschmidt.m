function [ Q ] = mgschmidt( V )
%MGSCHMIDT  Modified Gram-Schmidt algorithm.
%   Given a matrix V - size D x K, where K <= D - of K linearly independent
%   column vectors, MGSCHMIDT(V) returns a set of K orthonormal basis 
%   vectors Q s.t. span(Q) = span(V).
%

    [m, n] = size(V);
    if n > m
        error('Number of columns should not be more than number of rows.');
    end

    % Initialize:
    Q = zeros([m n]);
    qnorms = zeros([n 1]);
    
    % Loop:
    Q(:,1) = V(:,1);
    qnorms(1) = norm(Q(:,1));
    for i = 2:n
        vi = V(:,i);
        Qi = Q(:,1:i-1);
        Q(:,i) = vi - Qi* ((Qi'*vi)./(qnorms(1:i-1).^2)); 
        qnorms(i) = norm(Q(:,i));
    end
    
    Q = Q*diag(1./qnorms);
end

