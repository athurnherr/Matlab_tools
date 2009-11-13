%======================================================================
%                    I F M _ L A D C P 2 A N T S . M 
%                    doc: Sun Jan 22 15:19:00 2006
%                    dlm: Mon Oct 12 22:58:20 2009
%                    (c) 2006 A.M. Thurnherr
%                    uE-Info: 68 0 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% export IfM-GEOMAR LADCP output to ANTS file
%
% USAGE: IfM_LADCP2ANTS(dr,p,outBaseName)
%

% HISTORY:
%	Jul 21, 2008: - created from [LDEO_LADCP2ANTS.m]
%	Jul 22, 2008: - cosmetics
%	Aug 26, 2008: - cosmetics
%	Oct 12, 2009: - adapted to new struct2ANTS

function [] = IfM_LADCP2ANTS(dr,p,obn)

	%----------------------------------------------------------------------
	% INVERSE SOLUTION
	%----------------------------------------------------------------------

	prof.name = dr.name;
	prof.cruise = p.cruise_id;
	prof.software = p.software;
	prof.magdecl = p.magdev;	% always zero in V10.6
	prof.procdir = pwd;
	
	prof.start_date  = sprintf('%d/%02d/%02d',p.time_start(1),p.time_start(2),p.time_start(3));
	prof.start_time	 = sprintf('%02d:%02d:%02d',p.time_start(4),p.time_start(5),p.time_start(6));

	prof.end_date    = sprintf('%d/%02d/%02d',p.time_end(1),p.time_end(2),p.time_end(3));
	prof.end_time	 = sprintf('%02d:%02d:%02d',p.time_end(4),p.time_end(5),p.time_end(6));

	prof.median_time = sprintf('%02d:%02d:%02d',dr.date(4),dr.date(5),dr.date(6));

	prof.lat 		= dr.lat; 			  prof.lon  	  = dr.lon;				% (start+end)/2
	prof.mean_lat 	= mean(dr.shiplat);   prof.mean_lon   = mean(dr.shiplon);
	prof.median_lat = median(dr.shiplat); prof.median_lon = median(dr.shiplon);
	prof.start_lat	= dr.shiplat(1);	  prof.start_lon  = dr.shiplon(1);
	prof.end_lat	= dr.shiplat(end);	  prof.end_lon	  = dr.shiplon(end);
	i_bot = find(dr.zctd==min(dr.zctd));
	prof.bot_lat	= dr.shiplat(i_bot);  prof.bot_lon    = dr.shiplon(i_bot);

	prof.depth = dr.z;
	prof.max_depth = max(prof.depth);
	
	prof.u	   = dr.u;
	prof.dn_u  = dr.u_do;
	prof.up_u  = dr.u_up;
	prof.v     = dr.v;
	prof.dn_v  = dr.v_do;
	prof.up_v  = dr.v_up;
	
	prof.u_fromshear = dr.u_shear_method;
	prof.v_fromshear = dr.v_shear_method;

	prof.samp  = dr.nvel;
	prof.err   = dr.uerr;
	prof.range = dr.range;
	if existf(dr,'ensemble_vel_err')
		prof.ensemble_vel_err = dr.ensemble_vel_err;
	end

	struct2ANTS(prof,sprintf('%s.mat',f.res),sprintf('%s.prof',obn));

	%----------------------------------------------------------------------
	% SADCP
	%----------------------------------------------------------------------

	if existf(dr,'u_sadcp')

		SADCP.name = prof.name;
		SADCP.cruise = prof.cruise;
		SADCP.software = prof.software;
	    SADCP.magdecl = prof.magdecl;
		SADCP.procdir = prof.procdir;
		SADCP.date = sprintf('%d/%02d/%02d',dr.date(1),dr.date(2),dr.date(3)); % median
		SADCP.time = prof.median_time;
		SADCP.lat  = prof.lat; SADCP.lon  = prof.lon;
		SADCP.start_lat  = prof.start_lat; SADCP.start_lon  = prof.start_lon;
		SADCP.end_lat  = prof.end_lat; SADCP.end_lon  = prof.end_lon;
		SADCP.mean_lat  = prof.mean_lat; SADCP.mean_lon  = prof.mean_lon;
		SADCP.median_lat  = prof.median_lat; SADCP.median_lon  = prof.median_lon;

		SADCP.depth = dr.z_sadcp;
		SADCP.max_depth = max(dr.z_sadcp);

		SADCP.u		= dr.u_sadcp;
		SADCP.v		= dr.v_sadcp;
		if existf(dr,'uerr_sadcp')			% V7 does not have this
			SADCP.err	= dr.uerr_sadcp;
		end
		
		struct2ANTS(SADCP,sprintf('%s.mat',f.res),sprintf('%s.SADCP',obn));
		
	end

	%----------------------------------------------------------------------
	% BT
	%----------------------------------------------------------------------

	if existf(dr,'ubot')
		BT.name = prof.name;
		BT.cruise = prof.cruise;
		BT.software = prof.software;
		BT.magdecl = prof.magdecl;
		BT.procdir = prof.procdir;
		BT.date = sprintf('%d/%02d/%02d',dr.date(1),dr.date(2),dr.date(3)); % median
		BT.time = prof.median_time;
		BT.lat  = prof.bot_lat;
		BT.lon  = prof.bot_lon;

		BT.depth = dr.zbot;
		BT.max_depth = max(dr.zbot);

		BT.u		= dr.ubot;
		BT.v		= dr.vbot;
		BT.err		= dr.uerrbot;
		
		struct2ANTS(BT,sprintf('%s.mat',f.res),sprintf('%s.BT',obn));
	end
	


