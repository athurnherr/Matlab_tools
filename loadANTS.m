%======================================================================
%                    L O A D A N T S . M 
%                    doc: Thu Jul 21 22:53:21 2011
%                    dlm: Thu Jul 21 23:43:06 2011
%                    (c) 2011 A.M. Thurnherr
%                    uE-Info: 61 60 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================

% NOTES:
%	- very restrictive subset of ANTS standard:
%		= no empty lines
%		- no in-record comments

% HISTORY:
%	Jul 21, 2011: - began working on it

function dta_struct = loadANTS(file_name)

fid = fopen(file_name);										% open file
if fid < 0
	error(ferror(fid));
end

dta_struct = struct([]);

l = fgetl(fid);												% handle metadata
while ischar(l) & regexp(l,'^#')
	if regexp(l,'^#ANTS#ERROR#')
		error(l);
	elseif regexp(l,'^#ANTS#PARAMS#')
		params = regexp(l,'(\w+){([^}]*)}','tokens');
		for i=1:length(params)
			if strcmp(params{i}{2},'')
				dta_struct = rmfield(dta_struct,params{i}{1});
			else
				dta_struct = setfield(dta_struct,params{i}{1},params{i}{2});
			end % if
		end % for
	elseif regexp(l,'^#ANTS#FIELDS#')
		field = regexp(l,'{([^}]*)}','tokens');
	end % elseif
	l = fgetl(fid);
end % while

if ~ischar(l)												% EOF
	close(fid);
	return
end

fmt = '';													% construct scanf format
for i=1:length(field)
	fmt = [fmt ' %f'];
end

rec1 = sscanf(l,fmt);										% split first record
dta = fscanf(fid,fmt);										% read & split remaining records

for i=1:length(field)										% copy to structure
	disp(field{i});
	keyboard
	dta_struct = setfield(dta_struct,field{i},[rec1(i); dta(:,i)]);
end

flose(fid);

return 
