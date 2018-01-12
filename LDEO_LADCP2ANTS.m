%======================================================================
%                    L D E O _ L A D C P 2 A N T S . M 
%                    doc: Sun Jan 22 15:19:00 2006
%                    dlm: Sun Feb 12 18:48:25 2017
%                    (c) 2006 A.M. Thurnherr
%                    uE-Info: 31 43 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% export LDEO LADCP output to ANTS file
%
% USAGE: LDEO_LADCP2ANTS(dr,f,p,ps,outBaseName)
%

% HISTORY:
%  Jan 22, 2006: - created
%  Feb  4, 2006: - added BT & SADCP profiles
%  Feb  8, 2006: - made compatible with ANTS V7
%  Feb 26, 2006: - made ensemble_vel_err optional (not set on ps.shear = 2)
%  Apr 25, 2006: - suppress output of empty SADCP,BT files
%  Aug 21, 2006: - added additional lat/lon output
%  Nov  9, 2006: - added additional time output (requiring p input)
%  Jul 17, 2008: - added cruise, software, magdecl, procdir info
%  Apr 23, 2009: - added global var EXPORT_CTD_DATA
%  Oct 12, 2009: - adapted to new struct2ANTS
%  Mar 18, 2013: - added support for global STRUCT2ANTS.verb
%  Jun 24, 2013: - added blen, nbin, blnk, dist to output (DL/UL separately); V10
%                - added %depth_resolution %ADCP_superens_dz to output, requiring ps as
%                  additional input
%  Nov 10, 2013: - added prof.dayNo
%  Jun 12, 2015: - made dr.shiplat & CTD fields optional
%  Feb 12, 2017: - made backward compatible

function [] = LDEO_LADCP2ANTS(dr,f,p,ps,obn)

    global STRUCT2ANTS;                                                 % suppress diagnostic messages
    STRUCT2ANTS.verb = 0;

    %----------------------------------------------------------------------
    % INVERSE SOLUTION
    %----------------------------------------------------------------------

    prof.name = dr.name;
    prof.cruise = p.cruise_id;
    prof.software = p.software;
    prof.magdecl = p.drot;
    prof.procdir = pwd;

	if isfield(p,'blen_d')
	    prof.DL_bin_length  = p.blen_d;
    	prof.DL_bins        = p.nbin_d;
	    prof.DL_blanking    = p.blnk_d;
	    prof.DL_bin1_dist   = p.dist_d;
	end

    if isfield(p,'nbin_u')
        prof.UL_bin_length  = p.blen_u;
        prof.UL_bins        = p.nbin_u;
        prof.UL_blanking    = p.blnk_u;
        prof.UL_bin1_dist   = p.dist_u;
    end

    prof.ADCP_superens_dz = p.avdz;
	prof.depth_resolution = ps.dz;
	
	prof.start_date  = sprintf('%d/%02d/%02d',p.time_start(1),p.time_start(2),p.time_start(3));
	prof.start_time	 = sprintf('%02d:%02d:%02d',p.time_start(4),p.time_start(5),p.time_start(6));
	prof.dayNo       = datenum(p.time_start) - datenum(p.time_start(1),1,1) + 1;

	prof.end_date    = sprintf('%d/%02d/%02d',p.time_end(1),p.time_end(2),p.time_end(3));
	prof.end_time	 = sprintf('%02d:%02d:%02d',p.time_end(4),p.time_end(5),p.time_end(6));

	prof.median_time = sprintf('%02d:%02d:%02d',dr.date(4),dr.date(5),dr.date(6));

	prof.lat = dr.lat; prof.lon = dr.lon;				% (start+end)/2
	if existf(dr,'shiplat')
		prof.mean_lat	= mean(dr.shiplat);   prof.mean_lon   = mean(dr.shiplon);
		prof.median_lat = median(dr.shiplat); prof.median_lon = median(dr.shiplon);
		prof.start_lat	= dr.shiplat(1);	  prof.start_lon  = dr.shiplon(1);
		prof.end_lat	= dr.shiplat(end);	  prof.end_lon	  = dr.shiplon(end);
		i_bot = find(dr.zctd==min(dr.zctd));
	    prof.bot_lat    = dr.shiplat(i_bot);  prof.bot_lon    = dr.shiplon(i_bot);
	end	    

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

	if existf(dr,'ctd_t')
		prof.temp  = dr.ctd_t;
		prof.salin = dr.ctd_s;
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
		if existf(prof,'start_lat')
			SADCP.start_lat  = prof.start_lat; SADCP.start_lon	= prof.start_lon;
			SADCP.end_lat  = prof.end_lat; SADCP.end_lon  = prof.end_lon;
			SADCP.mean_lat	= prof.mean_lat; SADCP.mean_lon  = prof.mean_lon;
	        SADCP.median_lat  = prof.median_lat; SADCP.median_lon  = prof.median_lon;
	    end

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
		if existf(prof,'bot_lat')
			BT.lat  = prof.bot_lat;
			BT.lon  = prof.bot_lon;
		else
			BT.lat = prof.lat;
			BT.lon = prof.lon;
		end

		BT.depth = dr.zbot;
		BT.max_depth = max(dr.zbot);

		BT.u		= dr.ubot;
		BT.v		= dr.vbot;
		BT.err		= dr.uerrbot;
		
		struct2ANTS(BT,sprintf('%s.mat',f.res),sprintf('%s.BT',obn));
	end
	
	%----------------------------------------------------------------------
	% CTD Data
	%----------------------------------------------------------------------

	global EXPORT_CTD_DATA;
	if EXPORT_CTD_DATA
		CTD.name = prof.name;
		CTD.cruise = prof.cruise;
		CTD.software = prof.software;
		CTD.procdir = prof.procdir;
		CTD.date = sprintf('%d/%02d/%02d',dr.date(1),dr.date(2),dr.date(3)); % median
		CTD.time = prof.median_time;
		CTD.lat  = prof.lat;
		CTD.lon  = prof.lon;
		CTD.ITS = 90;
		CTD.depth = dr.z;
		CTD.temp  = dr.ctd_t;
		CTD.salin = dr.ctd_s;

		struct2ANTS(CTD,sprintf('%s.mat',f.res),sprintf('%s.CTD',obn));
	end
