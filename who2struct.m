%======================================================================
%                    M K S T R U C T . M 
%                    doc: Wed Apr 19 12:33:01 2006
%                    dlm: Wed Apr 19 13:10:52 2006
%                    (c) 2006 A.M. Thurnherr
%                    uE-Info: 16 0 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% structify workspace
%

varlist=who;

for i=1:length(varlist)
	eval(sprintf('struct.%s = %s; clear %s;',varlist{i},varlist{i},varlist{i}));
end

clear i;
clear varlist;
