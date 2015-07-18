function [ out ] = soft_thresh( X, MU )
%SOFT_THRESH	Soft threshold.
%   Returns the soft threshold of X w.r.t. MU > 0.

    out = sign(X).*max(abs(X) - MU, 0);

end

