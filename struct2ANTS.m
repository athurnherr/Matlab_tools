%======================================================================
%                    S T R U C T 2 A N T S . M 
%                    doc: Thu Oct 20 11:48:17 2005
%                    dlm: Fri Jan  6 09:31:38 2012
%                    (c) 2005 A.M. Thurnherr
%                    uE-Info: 50 0 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% export Matlab structure to ANTS file
%
% USAGE: struct2ANTS(struct,dependencies,outFileName)
%
% NOTES:
%	- <dependencies> can be a string of a cell array of strings
%	- scalar strings & numbers become %PARAMs
%	- row and column vectors (which can be mixed) become FIELDs
%	- incompatible vectors, as well as other data types, are skipped

% HISTORY:
%  Oct 20, 2005: - created
%  Nov 30, 2005: - BUG: string %PARAMs have to be quoted, e.g. if containing +
%  Apr 19, 2006: - changed output number format according to $# in perlvar(1)
%  Nov  6, 2006: - made output into doubles for increased precision
%  Nov 16, 2007: - replaced cell2mat() by char()
%  Apr 15, 2008: - added vector-compatibility test
%				 - cosmetics
%  Oct 12, 2009: - added ifn (ANTS 4.0: deps)
%  Oct 13, 2009: - allowed for NULL ifn, ofn
%  Oct 13, 2010: - allowed for multiple dependencies
%				 - added usage help
%  Jul 23: 2011: - BUG: empty dep did not work
%  Jul 24, 2011: - BUG: PARAMS with % did not work
%  Jul 25, 2011: - commented out diagnostic message about skipped incompatible vectors
%  Dec 30, 2011: - workaround for Matlab R11b bug: /tmp/foo cannot be written, /../tmp/foo can

function [] = struct2ANTS(struct,deps,ofn)

	if nargin ~= 3
		help struct2ANTS
		return
	end

	if iscell(deps)
		dlist = sprintf('%s,',deps{:});
	else
		dlist = sprintf('%s',deps);
	end
	
	[ldef,dta] = parseStruct(struct,'','',[],ofn);
	save /../tmp/.struct2ANTS dta -ASCII -DOUBLE;	% ARGH Matlab R11b on Freebsd 8.2 requires this weird path
	
	if length(ofn) == 0
		system(sprintf('list -M%%.15g -d ''%s'' %s /tmp/.struct2ANTS',dlist,ldef));
	else
		system(sprintf('list -M%%.15g -d ''%s'' %s /tmp/.struct2ANTS > %s',dlist,ldef,ofn));
	end

%======================================================================

function [ldef,dta] = parseStruct(struct,ldef,fpref,dta,ofn);

	fname = fieldnames(struct);
	for i=1:length(fname)
		fns = char(fname(i));
		f = getfield(struct,fns);
		if isstruct(f)
			[ldef,dta] = parseStruct(f,ldef,[fns '.'],dta,ofn);
		elseif ischar(f)
			f = strrep(f,'%','%%');				% must quote %s
			f = strrep(f,'$','\\\$');			% presumably also $s
			ldef = sprintf('%%%s%s="\\"%s\\"" %s',fpref,fns,f,ldef);
		elseif isnumeric(f)
			[r c] = size(f);
			if r+c == 2
				ldef = sprintf('%%%s%s=%.15g %s',fpref,fns,f,ldef);
			else
				ldef = sprintf('%s%s%s= ',ldef,fpref,fns);
				if isempty(dta), ndta = max(r,c);
				else, 			 ndta = size(dta,1);
				end
				if 	   r==1 && length(f)==ndta, dta = [dta,f'];
				elseif c==1 && length(f)==ndta, dta = [dta,f];
				else, 1; %disp(sprintf('%s: incompatible %d x %d array %s skipped',ofn,r,c,fns));
				end
			end
		else
			disp(sprintf('%s: field %s%s skipped',ofn,fpref,fns));
		end
	end

				
	
