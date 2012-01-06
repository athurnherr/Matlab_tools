%======================================================================
%                    U H _ L A D C P S H E A R 2 A N T S . M 
%                    doc: Thu Sep 30 11:06:14 2010
%                    dlm: Wed Oct 13 11:45:10 2010
%                    (c) 2006 A.M. Thurnherr
%                    uE-Info: 24 56 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% export UH-processed LADCP shear output to ANTS file
%
% USAGE: UH_LADCPshear2ANTS(stn|[stns])
%
% NOTES:
%	- execute this function in [./casts] subdir
%	- output files <stn>.sh are written in current directory
%	- run_name = 'h' (defined in [proc/set_da.m]) is assumed

% HISTORY:
%	Sep 30, 2010: - created
%	Oct 11, 2010: - BUG: merge output is variance, rather than stddev
%	Oct 13, 2010: - modified to be callable from [./casts] subdir
%				  - added usage info when called without args
%				  - added option to call with vector
%				  - adapted to include both dependencies

function [] = UH_LADCPshear2ANTS(stn)

	if nargin~=1
		help UH_LADCPshear2ANTS
		return
	end

	if length(stn) > 1
		for i=1:length(stn)
			UH_LADCPshear2ANTS(stn(i))
		end
		return
	end

	run_name = 'h';

	subdir = dir(sprintf('*%03d',stn));
	if length(subdir) ~= 1
		error Cannot determine cast subdirectory
	end
	
	dc_file = sprintf('%s/merge/%s_dn.mat',subdir.name,run_name);
	uc_file = sprintf('%s/merge/%s_up.mat',subdir.name,run_name);
	
	load(dc_file)
	dc_U = U; dc_V = V; dc_W = W;
	load(uc_file)
	uc_U = U; uc_V = V; uc_W = W;

	goodbins = find(dc_U(:,2)>0 | uc_U(:,2)>0);
	i1 = min(goodbins); i2 = max(goodbins);

	prof.depth 		= dc_U(i1:i2,1);

	prof.dc_nshear	= dc_U(i1:i2,2);
	prof.dc_u_z		= dc_U(i1:i2,3);
	prof.dc_u_z_sig	= sqrt(dc_U(i1:i2,4));
	prof.dc_v_z		= dc_V(i1:i2,3);
	prof.dc_v_z_sig	= sqrt(dc_V(i1:i2,4));
	prof.dc_w_z		= dc_W(i1:i2,3);
	prof.dc_w_z_sig	= sqrt(dc_W(i1:i2,4));

	prof.uc_nshear	= uc_U(i1:i2,2);
	prof.uc_u_z		= uc_U(i1:i2,3);
	prof.uc_u_z_sig	= sqrt(uc_U(i1:i2,4));
	prof.uc_v_z		= uc_V(i1:i2,3);
	prof.uc_v_z_sig	= sqrt(uc_V(i1:i2,4));
	prof.uc_w_z		= uc_W(i1:i2,3);
	prof.uc_w_z_sig	= sqrt(uc_W(i1:i2,4));

	struct2ANTS(prof,{dc_file,uc_file},sprintf('%03d.sh',stn));
