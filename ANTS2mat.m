%======================================================================
%                    A N T S 2 M A T . M 
%                    doc: Thu Aug  4 11:04:13 2011
%                    dlm: Thu Aug  4 11:04:19 2011
%                    (c) 2011 A.M. Thurnherr
%                    uE-Info: 11 0 NIL 0 0 72 0 2 4 NIL ofnI
%======================================================================

function [] = ANTS2mat(in_file,var_name,out_basename)
	eval(sprintf('%s = loadANTS(''%s'');',var_name,in_file));
	eval(sprintf('save %s %s',out_basename,var_name));

