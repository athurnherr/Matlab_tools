%======================================================================
%                    M K E P S . M 
%                    doc: Thu Oct 20 11:48:17 2005
%                    dlm: Wed Nov 30 10:59:23 2005
%                    (c) 2005 A.M. Thurnherr
%                    uE-Info: 15 41 NIL 0 0 72 2 2 4 NIL ofnI
%======================================================================
%
% save current figure to eps file
%
% USAGE: mkeps(outFileName)
%

function [] = mkeps(ofn)
	eval(sprintf('print -depsc2 %s',ofn));

