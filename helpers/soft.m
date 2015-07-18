function [ out ] = soft( X, MU )
%SOFT	Soft threshold.
%   Returns the soft threshold of X w.r.t. MU > 0.

    out = sign(X).*max(abs(X) - MU, 0);

end

