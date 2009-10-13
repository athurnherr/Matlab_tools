function hh = xerrorbar(x, y, l,u,symbol)
%XERRORBAR Error bar plot.
%
%   XERRORBAR(X,Y,L,U) behaves similar to ERRORBAR, from which it was 
%   derived
%
%   Global Variables:
%	TICSLEN		half-length of ticmarks in terms of y units;
%			+ve values: y units; 
%			-ve values: fraction of y total y-range;
%			default: -0.005
%	ERRORBARS_ONLY	do not plot data points

%======================================================================
%                    X E R R O R B A R . M 
%                    doc: Sun Feb 23 08:55:37 2003
%                    dlm: Tue Mar 11 11:52:52 2003
%                    (c) 2003 Mathworks; changes by A.M. Thurnherr
%                    uE-Info: 137 49 NIL 0 0 72 2 2 8 NIL ofnI
%======================================================================

% HISTORY:
%	Feb 23, 2003: - created from [errorbar.m]
%	Mar 10, 2003: - added TICSLEN
%	Mar 11, 2003: - changed TICSLEN sign convention
%		      - added ERRORBARS_ONLY

global TICSLEN; if isempty(TICSLEN), TICSLEN = -0.005; end
global ERRORBARS_ONLY;

if min(size(y))==1,
  npt = length(y);
  x = x(:);
  y = y(:);
    if nargin > 2,
        if ~isstr(l),  
            l = l(:);
        end
        if nargin > 3
            if ~isstr(u)
                u = u(:);
            end
        end
    end
else
  [npt,n] = size(y);
end

if nargin == 3
    if ~isstr(l)  
        u = l;
        symbol = '-';
    else
        symbol = l;
        l = x;
        u = x;
        x = y;
        [m,n] = size(x);
        y(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin == 4
    if isstr(u),    
        symbol = u;
        u = l;
    else
        symbol = '-';
    end
end


if nargin == 2
    l = x;
    u = x;
    x = y;
    [m,n] = size(x);
    y(:) = (1:npt)'*ones(1,n);;
    symbol = '-';
end

u = abs(u);
l = abs(l);
    
if isstr(x) | isstr(y) | isstr(u) | isstr(l)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(l)) | ~isequal(size(x),size(u)),
  error('The sizes of X, Y, L and U must be the same.');
end

if TICSLEN < 0
	tee = (max(y(:))-min(y(:))).*-TICSLEN;
else
	tee = TICSLEN;
end
yl = y - tee;
yr = y + tee;
xtop = x + u;
xbot = x - l;
n = size(x,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
yb = zeros(npt*9,n);
yb(1:9:end,:) = y;
yb(2:9:end,:) = y;
yb(3:9:end,:) = NaN;
yb(4:9:end,:) = yl;
yb(5:9:end,:) = yr;
yb(6:9:end,:) = NaN;
yb(7:9:end,:) = yl;
yb(8:9:end,:) = yr;
yb(9:9:end,:) = NaN;

xb = zeros(npt*9,n);
xb(1:9:end,:) = xtop;
xb(2:9:end,:) = xbot;
xb(3:9:end,:) = NaN;
xb(4:9:end,:) = xtop;
xb(5:9:end,:) = xtop;
xb(6:9:end,:) = NaN;
xb(7:9:end,:) = xbot;
xb(8:9:end,:) = xbot;
xb(9:9:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

h = plot(xb,yb,esymbol); hold on
if ~ERRORBARS_ONLY, h = [h;plot(x,y,symbol)]; end

if ~hold_state, hold off; end

if nargout>0, hh = h; end
