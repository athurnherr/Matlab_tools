%======================================================================
%                    E X P O R T _ L A D C P 
%                    doc: Tue Sep 16 12:04:42 2008
%                    dlm: Tue Sep 16 12:18:32 2008
%                    (c) 2008 A.M. Thurnherr
%                    uE-Info: 30 56 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% Synopsis: export list of LADCP stations to ANTS
%
% Usage: export_LADCP(stns)
%
% Notes:
%	- file format (LDEO, UH, IfM) determined automatically
%	- UH not yet implemented (different file names; no structures in mat files)
%	- 3-digit zero-padded station basename assumed
%	- non-existing stations are skipped


% HISTORY:
%	Sep 16, 2008: - created

function [] = export_LADCP(stns)

for s = stns
	bn = sprintf('%03d',s);
	if exist([bn '.mat'],'file')
		load(bn);
		if exist('d_samp','var')	% UH processed
			error('UH file format not yet implemented');			
		elseif isfield(p,'magdev')	% IfM processed
			IfM_LADCP2ANTS(dr,p,bn);
		else						% LDEO processed
			LDEO_LADCP2ANTS(dr,p,bn);
		end
	else
		disp(sprintf('skipping station %d',s));
	end % if exist mat file
end % station loop