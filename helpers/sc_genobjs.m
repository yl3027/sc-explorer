function [ scobjs ] = sc_genobjs( d, n, subs, varargin )
%SC_GENOBJS     Generates objects for a SC problem.
%
%   Usage:  [ SCOBJS ]  = SC_GENOBJS( D, N SUBS )
%           [ ... ]     = SC_GENOBJS( ... , SUBALLOC )
%           [ ... ]     = SC_GENOBJS( ... , COORDDISTR )
%           [ ... ]     = SC_GENOBJS( ... , SUBALLOC, COORDDISTR )
%
%   D is the ambient dimension of the data. N is the number of data points.
%
%   SUBS may be an array of the subspace dimensions - these should take 
%   values from the range 0:D. In this case the bases are chosen randomly.
%   Alternatively SUBS may also be a cell array of pre-chosen basis
%   matrices. In both cases, K = numel(SUBS) subspaces are generated.
%       e.g.        SUBS = randi(5, [3 1])
%       e.g.        [Q, ~] = qr(randn(D));  SUBS = { Q(:,1:2)   Q(:,3:5) };
%
%   SUBALLOC should be a size K array of nonnegative values containing the
%   the relative chance for allocating a point to each subspace.
%       Default:    SUBALLOC = ones(K,1)/K
%
%   COORDDISTR can either be a function handle taking a positive integer M
%   as the argument and returning a random array of M coordinates, or a 
%   size K cell array of function handles for each subspace - in which case 
%   the function handles should not take arguments.
%       Default:    COORDDISTR = @(m) (randn(m,1) - 0.5) * 2
%       e.g.        COORDDISTR = @(m) randn(m,1)
%       e.g.        COORDDISTR = { @() rand(5,1)    @() randn(2,1) }
%

    %% Initialize:
    Y = zeros([d n]);
    K = numel(subs);
    
    %% Parse arguments & generate bases:
    badarg = 'One or more invalid arguments provided.';
    
    % Subs - variable subs will store bases, subdims will store dimensions:
    if isnumeric(subs)
        subdims = subs;
        subs = cell(K,1);
        
        for k = 1:K
           subs{k} = mgschmidt( randn(d, subdims(k)) ); 
        end
    elseif iscell(subs)
        subdims = cellfun(@(b) size(b,2), subs);
    else
        error(badarg);
    end
    
    % Optional arguments suballoc and coorddistr:
    switch numel(varargin)
        case 0      % default
            suballoc = ones(K,1)/K;
            coorddistr = @(m, k) (randn(m,1) - 0.5) * 2;
            
        case 1      % could correspond to either suballoc or coorddistr
            temp{1} = process_suballoc( varargin{1}, K );
            temp{2} = process_coorddistr( varargin{1}, K );
            
            if ~isempty(temp{1})
                suballoc = temp{1};
            elseif ~isempty(temp{2})
                coorddistr = temp{2};
            else
                error(badarg);
            end
            
        case 2      % 1st is for suballoc and 2nd is for coorddistr
            suballoc = process_suballoc( varargin{1}, K );
            coorddistr = process_coorddistr( varargin{2}, K );
            
            if isempty(suballoc) || isempty(coorddistr)
                error(badarg);
            end
            
        otherwise
            error('Too many arguments.');
    end
    
    %% Distribute points over subspaces:
    % pts_sub: specify a point index, get its subspace index
    pts_sub = repmat(rand(1, n), [K 1]) >= repmat(cumsum(suballoc(:)), [1 n]);
    pts_sub = sum(pts_sub, 1)+1;
    
    % sub_pts: specify a subspace index, get its point index
    sub_pts = arrayfun(@(i) find(pts_sub == i), 1:5, 'UniformOutput', false);

    % Finally, randomly put the point on the associated subspace
    for i = 1:n
        k = pts_sub(i);
        Y(:,i) = subs{k}*coorddistr(subdims(k),k);
    end
    
    %% Collect everything and return:
    scobjs.Y = Y;
    scobjs.subdims = subdims;
    scobjs.subbases = subs;
    scobjs.pts_sub = pts_sub;
    scobjs.sub_pts = sub_pts;
    
end

function [ suballoc ] = process_suballoc( var, k )
    test1 = isnumeric(var);
    test2 = prod(var > 0);
    test3 = numel(var) == k;
    if test1 && test2 && test3
        suballoc = var/sum(var(:));
    else
        suballoc = [];
    end
    
end

function [ coorddistr ] = process_coorddistr( var, k )
    vec = @(X) X(:);
    
    switch class(var)
        case 'function_handle'
            coorddistr = @(m,k) vec(var(m));
        case 'cell'
            test1 = numel(var) == k;
            test2 = prod(cellfun(@(b) isa(b, 'function_handle'), var));
            if test1 && test2 
                coorddistr = @(m,k) vec(var{k}());
            end 
        otherwise
            coorddistr = [];
    end
end