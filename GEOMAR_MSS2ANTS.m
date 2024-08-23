%======================================================================
%                    G E O M A R _ M S S 2 A N T S . M 
%                    doc: Thu Jan  2 13:11:21 2020
%                    dlm: Thu Jan  2 14:29:10 2020
%                    (c) 2020 A.M. Thurnherr
%                    uE-Info: 80 42 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================

% HISTORY:
%	Jan  2, 2020: - created from NOCS_VMP2ANTS

% EMAIL Marcus Dengler Jul 31, 2019:
%
% 1) 1x10^(-9)m^2s^(-3) is the noise level of the instrument. This is
% o.k. for the upper ocean, but not for the deep ocean. For Krho in the
% thermocline, this translated to about 2-3x10-6m^2s^(-1), which leads to
% negligible nutrient fluxes. All Sea & Sun profiler suffer from this
% elevated noise level. We think that one problem is the Sea & Sun
% transfers the voltage of the shear sensors, while Rockland sends the
% change of voltage. Both use 16 bit numbers for their transfer. However,
% it is not the full story, because theoretically, bandwidth would be
% sufficient to get a better noise level even when sending voltage (I
% think that the 16 bit A/D converter to be not as precise as they say it
% is).
%
% 2) Data should be good for profiler speeds above 0.2 m/s. However, the
% sinking velocity of the profiler should preferentially be 0.55 m/s. Is
% that the case? If not, you may want to add a couple of small steel
% rings to the front of the profiler. It is not that the data are bad if
% lower drop rates are used, it is just that the noise level goes up.
%
% 3) Have you removed the data that were automatically detected as spikes?
% For sensor 1, you get these from
%	i=find(df.spikeflag1.opti==0);
%	eps1good=df.eps1(i);
%
% 4) Also, it looks like that there is is still data affected by ship
% turbulence. I usually omit all data within the upper 10m. I have never
% seen ocean turbulence having eps larger than 1x10^(-4)m^2s^(-3). So I
% also flag all data showing eps > 1x10^(-4)m^2s^(-3) and it allows me to
% check if there is ship turbulence in deeper waters than 10m. This would
% be the case if values above 1x10^(-4)m^2s^(-3) occasionally show up
% between 10m-20m water depth. All ships have different propellers and
% different hull friction causing differences in ship turbulence.

function [] = GEOMAR_MSS2ANTS(fn_pat,id)
    global STRUCT2ANTS;                                                 % suppress diagnostic messages
    STRUCT2ANTS.verb = 0;

    ifn = sprintf(fn_pat,id);
    ofn = sprintf('%03d.MSS',id);
    load(ifn);
    
	prof.id 	= id;
	prof.eps_noise 		= 1e-9;
	prof.min_sinkvel	= 0.2;
	prof.min_depth		= 10;
	
	prof.press 	= df.p;
	prof.temp 	= df.t;
	prof.salin 	= df.salt;
	prof.depth 	= df.depth;
	prof.sinkvel = df.sinkvel;
	prof.eps1	 = df.eps1;
	prof.eps2	 = df.eps2;

	ibad = find(prof.sinkvel < prof.min_sinkvel);						% edit slow sink velocity
	prof.eps1(ibad) = NaN;
	prof.eps2(ibad) = NaN;
	
	ibad = find(prof.depth < prof.min_depth);						% edit shallow samples
	prof.eps1(ibad) = NaN;
	prof.eps2(ibad) = NaN;
	
	ibad = find(df.spikeflag1.opti ~= 0);								% apply spike edit filter
	prof.eps1(ibad) = NaN;
	ibad = find(df.spikeflag2.opti ~= 0);
	prof.eps2(ibad) = NaN;

	prof.epsavg  = nanmean([prof.eps1;prof.eps2]);

	struct2ANTS(prof,ifn,ofn);
