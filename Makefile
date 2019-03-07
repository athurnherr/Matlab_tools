#======================================================================
#                    M A K E F I L E 
#                    doc: Tue May 15 18:12:31 2012
#                    dlm: Fri Jan 12 17:42:13 2018
#                    (c) 2012 A.M. Thurnherr
#                    uE-Info: 15 5 NIL 0 0 72 0 2 4 NIL ofnI
#======================================================================

.PHONY: version
version:
	@sed -n '/^description =/s/description = //p' .hg/hgrc

.PHONY: publish
publish:
	-scp -Cr ../Matlab_tools ftp:public_hg
