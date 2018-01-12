%======================================================================
%                    N O C S _ V M P 2 A N T S . M 
%                    doc: Wed Aug 10 19:52:02 2016
%                    dlm: Wed Aug 10 20:43:57 2016
%                    (c) 2016 A.M. Thurnherr
%                    uE-Info: 38 33 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================

% HISTORY:
%	Aug 10, 2016: - created for DIMES UK2.5 data from Reykjavik

function [] = NOCS_VMP2ANTS(matf)
    global STRUCT2ANTS;                                                 % suppress diagnostic messages
    STRUCT2ANTS.verb = 0;

    load(matf);
	for id=1:length(d.stnid)
		if isfinite(d.ctdno(id))
			prof.id		= d.ctdno(id);
			obn			= sprintf('%03d',prof.id);
		else
			prof.id		= sprintf('VMP%03d',d.vmpno(id));
			obn			= prof.id;
		end
		prof.VMP_id		= d.vmpid(:,id)';
		prof.VMP_no 	= d.vmpno(id);
		prof.stn_id		= d.stnid(:,id)';
		prof.CTD_no		= d.ctdno(id);
		prof.lat	 	= d.startlat(id);
		prof.lon 		= d.startlon(id);
		prof.dn 		= d.startjday(id);
		prof.end_lat 	= d.endlat(id);
		prof.end_lon 	= d.endlon(id);
		prof.end_dn 	= d.endjday(id);
		prof.ITS 		= 90;
		prof.press 		= d.press(:,id);
		prof.temp		= d.temp(:,id);
		prof.salin 		= d.salin(:,id);
		prof.chi		= d.chi(:,id);
		prof.eps		= d.eps(:,id);
		struct2ANTS(prof,matf,sprintf('%s.VMP',obn));
	end
end
		
