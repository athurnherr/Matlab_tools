%======================================================================
%                    S T R U C T 2 A N T S . M 
%                    doc: Thu Oct 20 11:48:17 2005
%                    dlm: Tue Apr 15 14:43:45 2008
%                    (c) 2005 A.M. Thurnherr
%                    uE-Info: 16 56 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% export Matlab structure to ANTS file
%
% USAGE: struct2ANTS(struct,outFileName)
%
% NOTES:
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

function [] = struct2ANTS(struct,ofn)
	[ldef,dta] = parseStruct(struct,'','',[],ofn);
	save /tmp/.struct2ANTS dta -ASCII -DOUBLE;
	system(sprintf('list -M%%.15g %s /tmp/.struct2ANTS > %s',ldef,ofn));

%======================================================================

function [ldef,dta] = parseStruct(struct,ldef,fpref,dta,ofn);

	fname = fieldnames(struct);
	for i=1:length(fname)
		fns = char(fname(i));
		f = getfield(struct,fns);
		if isstruct(f)
			[ldef,dta] = parseStruct(f,ldef,[fns '.'],dta,ofn);
		elseif ischar(f)
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
				else, disp(sprintf('%s: incompatible %d x %d array %s skipped',ofn,r,c,fns));
				end
			end
		else
			disp(sprintf('%s: field %s%s skipped',ofn,fpref,fns));
		end
	end

				
	
