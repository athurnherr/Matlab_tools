function prof = readnetcdf(filename)

% Usage: prof = readnetcdf(filename)
%
% Read variables from a netCDF file.

ncid = netcdf.open(filename, 'NOWRITE');

% get variables
[ndims,nvars,natts,unlimdimid] = netcdf.inq(ncid);

for varid=0:nvars-1
	[varname,xtype,dimids,nvaratts] = netcdf.inqVar(ncid,varid);
	cmd = sprintf('prof.%s = netcdf.getVar(ncid,varid);',varname);
	eval(cmd);
end

gattvarid = netcdf.getConstant('NC_GLOBAL');
for gattid=0:natts-1
	attname = netcdf.inqAttName(ncid,gattvarid,gattid);
	cmd = sprintf('prof.%s = netcdf.getAtt(ncid,gattvarid,''%s'');',attname,attname);
	eval(cmd);
end

netcdf.close(ncid)


