%======================================================================
%                    U H _ L A D C P 2 A N T S . M 
%                    doc: Sun Jan 22 15:19:00 2006
%                    dlm: Mon Oct 12 22:57:17 2009
%                    (c) 2006 A.M. Thurnherr
%                    uE-Info: 53 24 NIL 0 0 72 0 2 4 NIL ofnI
%======================================================================
%
% export LDEO LADCP output to ANTS file
%
% USAGE: LADCP2ants(inFile,outBaseName)
%

% HISTORY:
%  Jan 22, 2006: - created
%  Nov  2, 2008: - BUG: v_var vas not exported because of typo
%  Oct 12, 2009: - adapted to new struct2ANTS

function [] = LADCP2ANTS(ifn,obn)

	eval(sprintf('load %s',ifn));

	prof.yrday = mean(txy_start_end(:,1));

	prof.lon = mean(txy_start_end(find(isfinite(txy_start_end(:,2))),2));
	prof.lat = mean(txy_start_end(find(isfinite(txy_start_end(:,3))),3));

	good = find(sm_mn_i > 0);
	prof.depth = d_samp(good);
	prof.max_depth = max(prof.depth);

	dn_bad = find(sm_dn_i == 0);
	up_bad = find(sm_up_i == 0);

	prof.u = su_mn_i(good);
	su_dn_i(dn_bad) = NaN; prof.dn_u = su_dn_i(good);
	su_up_i(up_bad) = NaN; prof.up_u = su_up_i(good);
	prof.v = sv_mn_i(good);
	sv_dn_i(dn_bad) = NaN; prof.dn_v = sv_dn_i(good);
	sv_up_i(up_bad) = NaN; prof.up_v = sv_up_i(good);

	prof.u_var = su_var_mn_i(good);
	su_var_dn_i(dn_bad) = NaN; prof.dn_u_var = su_var_dn_i(good);
	su_var_up_i(up_bad) = NaN; prof.up_u_var = su_var_up_i(good);
	prof.v_var = sv_var_mn_i(good);
	sv_var_dn_i(dn_bad) = NaN; prof.dn_v_var = sv_var_dn_i(good);
	sv_var_up_i(up_bad) = NaN; prof.up_v_var = sv_var_up_i(good);

	prof.samp = sn_mn_i(good);
	sn_dn_i(dn_bad) = NaN; prof.dn_samp = sn_dn_i(good);
	sn_up_i(up_bad) = NaN; prof.up_samp = sn_up_i(good);

	struct2ANTS(prof,ifn,sprintf('%s.prof',obn));

