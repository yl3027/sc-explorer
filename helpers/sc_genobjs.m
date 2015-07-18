function [ scobjs ] = sc_genobjs( d, n, subs, suballoc, coorddistr )
%SC_GENOBJS     Generates objects for a SC problem.
%
%   Usage:   [ SCOBJS ] = SC_GENOBJS( D, N SUBS, SUBALLOC, COORDDISTR )
%
%   D is the ambient dimension of the data. N is the number of data points.
%
%   SUBS may be an array of the subspace dimensions - these should take 
%   values from the range 0:D. In this case the bases are chosen randomly.
%   Alternatively SUBS may also be a cell array of pre-chosen basis
%   matrices. In both cases, K = numel(SUBS) subspaces are generated.
%       e.g.    SUBS = randi(5, [3 1])
%       e.g.    [Q, ~] = qr(randn(D));  SUBS = { Q(:,1:2)   Q(:,3:5) };
%
%   SUBALLOC should be a size K array of nonnegative values containing the
%   the relative chance for allocating a point to each subspace.
%
%   COORDDISTR can either be a function handle taking a positive integer M
%   as the argument and returning a random array of M coordinates, or a 
%   size K cell array of function handles for each subspace - in which case 
%   the function handles should not take arguments.
%       e.g.    COORDDISTR = @(n) randn(n,1)
%       e.g.    COORDDISTR = @(n) (rand(n,1) - 0.5) * 100
%       e.g.    COORDDISTR = { @() rand(5,1)    @() randn(2,1) }
%



end

