%======================================================================
%                    D E C _ T I M E . M 
%                    doc: Thu Mar  1 18:16:50 2012
%                    dlm: Thu Mar  1 18:18:15 2012
%                    (c) 2012 A.M. Thurnherr
%                    uE-Info: 15 0 NIL 0 0 72 0 2 4 NIL ofnI
%======================================================================
% 
%	dt = dec_time(time[,epoch])
%
% 	make ATNS dn field from matlab numeric time
%
% HISTORY:
%	Mar  1, 2012: - created

function dt=dec_time(time,varargin)

if nargin==2
	dt = time - datenum(varargin{1},1,1) + 1;
elseif nargin==1
	dv = datevec(time);
	dt = dec_time(time,dv(1));
else
	disp('dt=dec_time(time[,epoch])');
	error
end

	
