%======================================================================
%                    M M P 2 A N T S . M 
%                    doc: Tue Apr 21 17:31:52 2009
%                    dlm: Tue Oct 13 10:04:17 2009
%                    (c) 2009 A.M. Thurnherr
%                    uE-Info: 16 54 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================

% HISTORY:
%	Apr 21, 2009: - created
%	May 15, 2009: - added meta data (requires modified [mmp_pgrid_main.m])
%				  - added ancillary data (hdg, etc)
%				  - added depth calc
%	May 18, 2009: - added export of raw ACM file
%				  - BUG: hdg actually was vel_dir
%	Oct 13, 2009: - adapted to new struct2ANTS (V4.0: dependencies)

function mmp2ANTS(plist,epoch)

if nargin ~= 2											% default epoch could be dangerous
	error('Usage: mmp2ANTS(plist,epoch)');				% for year-end-spanning data sets
end

for p = plist

	%--------------------------------
	% EXPORT PRESSURE-GRIDDED PROFILE
	%--------------------------------

	okay = 1;												% attempt to load data
	eval(sprintf('load grd%04d',p),'okay = 0;');

	if okay

		disp(sprintf('exporting gridded profile %04d...',p));		% process
		
		%----------
		% META DATA
		%----------

		prof.MMP_id = MMP_id;
		prof.ACM_id = ACM_id;
		prof.experiment = experiment_name;

		prof.min_press = gmin;
		prof.max_press = gmax;
		prof.press_step = gstep;

		prof.ACM_calfile = acm_cal_filename;

		prof.vel_l_bound = vel_bounds(1) / 100;
		prof.vel_u_bound = vel_bounds(2) / 100;

		pos = sscanf(mooring_position,'[%d %f,%d %f]');
		if pos(1) >= 0, prof.lat = pos(1) + pos(2)/60;
		else, 			prof.lat = pos(1) - pos(2)/60;
		end
		if pos(3) >= 0, prof.lon = pos(3) + pos(4)/60;
		else, 			prof.lon = pos(3) - pos(4)/60;
		end

		prof.magdecl = 180 * mag_dev/pi;

		eval(sprintf('prof.start_dn%02d = %f;',epoch-2000,...	% start/stop times in ANTS dn format
			startdaytime - datenum(sprintf('1-1-%d 00:00:00',epoch)) + 1));
		eval(sprintf('prof.stop_dn%02d = %f;',epoch-2000,...
			stopdaytime - datenum(sprintf('1-1-%d 00:00:00',epoch)) + 1));

		%-----
		% DATA	
		%-----

		stimes = ctimave - datenum(sprintf('1-1-%d 00:00:00',epoch)) + 1;	% bin-averaged time in dn format
		igood = isfinite(stimes);
		eval(sprintf('prof.dn%02d = stimes(igood);',epoch-2000));
	
		prof.press = pgrid(igood);									% center of bins used for gridding
		if exist('sw_dpth','file')
			prof.depth = sw_dpth(prof.press',prof.lat);
		end
	    
		prof.binned_press = pave(igood);							% bin-averaged CTD data
		prof.temp	= tave(igood);
		prof.salin	= s_ave(igood);
		prof.theta0 = thetave(igood);
		prof.sigma0 = sigthave(igood);
		prof.cond	= cave(igood);
		prof.CTD_Nsamp = cscan2(igood) - cscan1(igood);
	    
		prof.u		= uave(igood) / 100;							% bin-averaged ACM data in [m/s]
		prof.v		= vave(igood) / 100;
		prof.w		= wave(igood) / 100;

		tmp = 180 * mvpdirave(igood)/pi;
		prof.hdg	= (270-tmp)-(fix((270-tmp)/360)*360);			% standard heading btw 0 and 360
		prof.pitchx	= aTxave(igood);
		prof.pitchy	= aTyave(igood);

		prof.dpdt	= dpdtave(igood);
		prof.ACM_Nsamp = ascan2(igood) - ascan1(igood);
	    
	    struct2ANTS(prof,sprintf('grd%04d.mat',p),sprintf('%04d.prof',p));
	    
	end % if grd file loaded

	%--------------------
	% EXPORT RAW PROFILES
	%--------------------

	okay = 1;														% attempt to load data
	eval(sprintf('load raw%04d',p),'okay = 0;');

	if okay

		disp(sprintf('exporting raw data %04d...',p));				% process
		
		ACM.Vab = Vab;
		ACM.Vcd = Vcd;
		ACM.Vef = Vef;
		ACM.Vgh = Vgh;

		ACM.aHx = aHx;
		ACM.aHy = aHy;
		ACM.aHz = aHz;
	    
		ACM.aTx = aTx;
		ACM.aTy = aTy;

	    struct2ANTS(ACM,sprintf('raw%04d.mat',p),sprintf('%04d.ACM',p));
	    
	end % if grd file loaded

end % for p
