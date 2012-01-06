% Usage: D = loadANTS(filename[,fieldname[,...]]);
%
% Examples:
%	prof = loadANTS('070.2db');
%		- read all fields from file 070.2db into matrix prof
%		- each field becomes a column
%	prof = loadANTS('070.2db','press','temp','salin');
%		- read pressure, temperature, and salinity fields from file 070.2db
%		  into matrix prof
%		- 1st column is pressure, 2nd column is temperature, 3rd column is
%		  salinity

%======================================================================
%                    L O A D A N T S . M 
%                    doc: Fri Sep 17 11:12:44 2010
%                    dlm: Fri Sep 17 11:41:01 2010
%                    (c) 2010 A.M. Thurnherr
%                    uE-Info: 25 29 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================

function D = loadANTS(file,varargin)

if nargin==1
	cmd = sprintf('data -Qw %s',file);
	[status,dta] = system(cmd);
	if status~=0
		error(sprintf('cmd "%s" failed',cmd));
	end
	nfields = sscanf(dta,'%d');
	cmd = sprintf('Cat -Q %s',file);
else
	nfields = nargin-1;
	cmd = 'list -Q';
	for i=1:nfields
	  cmd = sprintf('%s %s',cmd,varargin{i});
	end
	cmd = sprintf('%s %s',cmd,file);
end

[status,dta] = system(cmd);
if status~=0
	error(sprintf('cmd "%s" failed',cmd));
end

D = sscanf(dta,'%f',[nfields,inf])';
	
