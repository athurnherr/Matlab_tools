#======================================================================
#                    M A K E F I L E 
#                    doc: Tue May 15 18:12:31 2012
#                    dlm: Wed May 16 08:26:19 2012
#                    (c) 2012 A.M. Thurnherr
#                    uE-Info: 16 18 NIL 0 0 72 0 2 4 NIL ofnI
#======================================================================

.PHONY: version
version:
	@sed -n '/^description =/s/description = //p' .hg/hgrc

.PHONY: publish
publish:
	cd ..; \
	scp -Cr Matlab_tools miles:public_hg
