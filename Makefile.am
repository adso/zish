AUTHOR=@AUTHOR@
VERSION=@VERSION@
LICENSE=@LICENSE@

SED=@SED@
FIND=@FIND@
WGET=@WGET@
TAR=@TAR@
AR=@AR@
MKDIR_P=@MKDIR_P@

ZISH_SCRIPT=@ZISH_SCRIPT@
INSTALL_ZISH=@INSTALL_ZISH@

# copy system wide m4 macros to local file m4/aclocal.m4 and distribute them.
distro_type=@distro_type@
ACLOCAL_AMFLAGS = -I m4 --install  

# To force all templates being distributed
#EXTRA_DIST = src/input/*
SUBDIRS =   													# src output m4 src/input  #Compile and distribute
DIST_SUBDIRS = config  config/common	config/bconf    		# src output m4 #No compile but still distribute the


# Using shadow variables to let the user override the others during the build.
LIBS=@LIBS@
AM_CFLAGS=@CFLAGS@
AM_CXXFLAGS=@CXXFLAGS@
AM_CPPFLAGS=@CPPFLAGS@
AM_LDFLAGS=@LDFLAGS@

# configure get this values for the environment 
#HOME=@HOME@   
#USER=@USER@
libdir=@libdir@				# autoexported by autoconf 
includedir=@includedir@		# autoexported by autoconf 


# default installation directories. Not auto availables
#
#prefix=${}
#prefix=@prefix@
#exec_prefix=@exec_prefix@
#sysconfdir=@sysconfdir@
#datarootdir=@datarootdir@

#Automake standar directories
#top_buildir
#top_srcdir
#
#
#pkgdatadir
#pkgincludedir
#pkglibdir
#pkglibexecdir

# Be aware that underscore has a meaning in the left side of variables.
# Also the dir part in the variable name have a meaning too.It's a suffix 
# Prefix can be dir, noninst, etc.

# for futher reference and use in future. AM_PATH_PYTHON exported varriables.
#PYTHON=@PYTHON@
#PYTHON_VERSION=@PYTHON_VERSIONdistclean-am:@
#PYTHON_PLATFORM=@PYTHON_PLATFORM@
#PYTHON_PREFIX=@PYTHON_PREFIX@
#PYTHON_EXEC_PREFIX=@PYTHON_EXEC_PREFIX@
#pythondir=@pythondir@ 						# where the site-packages directory is
#pkgpythondir=@pkgpythondir@ 				# = pythondir/$(PKGDIR)
#pyexecdir=@pyexecdir@  					# c extensions are in this directory
#pkgpyexecdir=@pkgpyexecdir@				# = pyexecdir/$(PKGDIR)


# package and python related variables used. 
# When standard directories are not used dir suffix must be added.
#pkgdir=${abs_top_builddir}
#zishworkdir=@zishworkdir@        # this is for future nested configures
zishworkdir=${abs_top_srcdir}/src
zishcheckdir=${abs_builddir}/checks
zishpythonlibdir=@zishpythonlib@
zishpythonsitedir=@zishpythonsite@
zishpythondistutilsdir=@zishpythondistutils@
zishinstancename=zish_instance
zishinstancesdir=$(prefix)/zopeservers/instances
zishinstancedir=$(prefix)/zopeservers/instances/${zishinstancename}
zishinstancelink=${prefix}/srv/$(zishinstancename)
zisheggs=${prefix}/var/zopeservers/packages/eggs
zishpkg=${prefix}/var/zopeservers/packages/downloads
zishhtmldir=${HOME}/public_html/${zishinstancename}
zishvarfile=@zishvarfile@
templatesdir=@templatesdir@
outputdir=@outputdir@
missing_libs=@missing_libs@
missing_headers=@missing_headers@
distutilscfg=@distutilscfg@
plonever=@plonever@

CPPFLAGS_NONSTANDARD=@CPPFLAGS_NONSTANDARD@
LDFLAGS_NONSTANDARD=@LDFLAGS_NONSTANDARD@

HAVE_LIBZ=@HAVE_LIBZ@
HAVE_LIBJPEG=@HAVE_LIBJPEG@
HAVE_LIBFREETYPE=@HAVE_LIBFREETYPE@
HAVE_LIBREADLINE=@HAVE_LIBREADLINE@

LIBZ_CPPFLAGS=@LIBZ_CPPFLAGS@
LIBZ_LDFLAGS=@LIBZ_LDFLAGS@


TARGET=@TARGET@


#DISTCLEANFILES fails if a entire directories are specified
DISTCLEANFILES = zish.vars zish.log

# Makefile.am specific variables

#Let the source target type empty in order automake knows there is nothing to compile

#_DATA type of targets are not distributed by default so...

#this is only an excuse to build the directory.


#using variables in the file part make fails "make distcheck "
#dist_zishpythondistutils_SCRIPTS = '"'${outputdir}/sitecustomize.py
#dist_zishpythonsite_SCRIPTS = '"'${outputdir}/sitecustomize.py
#noinst_SCRIPTS = build-aux/install-zish-0.2.sh


# The  perfect excuse to make make to work :)
#pkg_DATA = zish.dummy


zishpythondistutils_DATA = ${abs_top_builddir}/output/distutils.cfg


all-custom-vars-am:
	@echo "prefix="'"'$(prefix)'"'  															>> ${abs_builddir}/zish.vars.tmp
	@echo "distro_type="'"'${distro_type}'"' 													>> ${abs_builddir}/zish.vars.tmp	
	@echo "PLATFORM_OPTIONS=' --with-threads --enable-shared --with-encoding=utf-8 '" 			>> ${abs_builddir}/zish.vars.tmp
	@echo "AM_CPPFLAGS="'"'${AM_CPPFLAGS}'"'											 		>> ${abs_builddir}/zish.vars.tmp
	@echo "AM_LDFLAGS="'"'${AM_LDFLAGS}'"' 														>> ${abs_builddir}/zish.vars.tmp
	@echo "top_distdir="'"'${top_distdir}'"'  													>> ${abs_builddir}/zish.vars.tmp
	@echo "abs_top_builddir="'"'${abs_top_builddir}'"'  										>> ${abs_builddir}/zish.vars.tmp
	@echo "abs_top_srcdir="'"'${abs_top_srcdir}'"'  											>> ${abs_builddir}/zish.vars.tmp
	@echo "abs_builddir="'"'${abs_builddir}'"'  												>> ${abs_builddir}/zish.vars.tmp
	@echo "abs_srcdir="'"'${abs_srcdir}'"'  													>> ${abs_builddir}/zish.vars.tmp
	@echo "zishworkdir="'"'${zishworkdir}'"'  													>> ${abs_builddir}/zish.vars.tmp
	@echo "libdir="'"'${libdir}'"'																>> ${abs_builddir}/zish.vars.tmp
	@echo "includedir="'"'${includedir}'"'	 													>> ${abs_builddir}/zish.vars.tmp
	@echo "zishpythonlibdir="'"'${zishpythonlib}'"' 											>> ${abs_builddir}/zish.vars.tmp
	@echo "zishpythonsitedir="'"'${zishpythonsite}'"'   										>> ${abs_builddir}/zish.vars.tmp
	@echo "zishpythondistutilsdir="'"'${zishpythondistutils}'"'  								>> ${abs_builddir}/zish.vars.tmp
	@echo "zishinstancename="'"'${zishinstancename}'"'  										>> ${abs_builddir}/zish.vars.tmp
	@echo "zishinstancesdir="'"'${zishinstancesdir}'"'   										>> ${abs_builddir}/zish.vars.tmp
	@echo "zishinstancedir="'"'${zishinstancedir}'"'   											>> ${abs_builddir}/zish.vars.tmp
	@echo "zisheggs="'"'${zisheggs}'"'   														>> ${abs_builddir}/zish.vars.tmp
	@echo "zishpkg="'"'${zishpkg}'"'						 									>> ${abs_builddir}/zish.vars.tmp
	@echo "zishhtmldir="'"'${zishhtmldir}'"'   													>> ${abs_builddir}/zish.vars.tmp
	@echo "templatesdir="'"'${templatesdir}'"'													>> ${abs_builddir}/zish.vars.tmp
	@echo "outputdir="'"'${outputdir}'"'  														>> ${abs_builddir}/zish.vars.tmp
	@echo "missing_libs="'"'${missing_libs}'"' 													>> ${abs_builddir}/zish.vars.tmp
	@echo "missing_headers="'"'${missing_headers}'"' 										 	>> ${abs_builddir}/zish.vars.tmp
	@echo "distutilscfg="'"'${distutilscfg}'"' 										 			>> ${abs_builddir}/zish.vars.tmp
	@echo "plonever="'"'${plonever}'"' 										 			        >> ${abs_builddir}/zish.vars.tmp
	@mv ${abs_builddir}/zish.vars.tmp ${abs_builddir}/zish.vars  



install-exec-zish-am:
	$(INSTALL_ZISH) do-make-install ;



uninstall-custom-am:
	@chmod a+rw -R ${prefix} ; \
	rm -rf ${prefix} ;



check-custom-am:
	@echo "test suite in **make** : check-custom-am " ; \
	echo "top_builddir :  ${top_builddir} " ; \
	echo "top_scrdir  :   ${top_srcdir} " ; \
	echo "pkgdir :  	  ${pkgdir} " ; \
	echo "pkgdatadir :    ${pkgdatadir} " ; \
	echo "abs_srcdir  :   ${abs_srcdir} " ; \
	echo "abs_builddir  : ${abs_builddir} " ; \
	echo "test suite in **install-zish.sh** : " ; \
	$(INSTALL_ZISH) tests ;



check-results-am:
	@echo "test suite in **make** : check-results-am " ; \
	echo "copying modified files at ${zishcheckdir}" ; \
	zishcheckdir=${zishcheckdir} ; \
	if test ! -e $$zishcheckdir  ; then  \
		$(MKDIR_P) $$zishcheckdir ; \
	fi ; \
	find ${abs_top_srcdir}/src -maxdepth 3  \
		 \( -type f -name "Makefile.*" -o -name "setup.*" \) \
		| while read I; do \
			cp $$I $$zishcheckdir ; \
		done ;


clean-custom-am:
	@zishworkdir=${zishworkdir} ; \
	abs_top_srcdir=${abs_top_srcdir} ;  \
	abs_top_builddir=${abs_top_builddir} ; \
	if test "$$abs_top_srcdir" = "$$abs_top_builddir" ; then \
		echo -e "src dir it's the same that build dir.\n Not cleaning..: ${abs_top_srcdir}" ; \
	else \
		echo "Cleaning abs_top_builddir..: ${abs_top_builddir}"  ; \
		rm -rf $$abs_top_builddir && cd $$abs_top_srcdir ; \
	fi ; 



distclean-custom-am:
	@echo "cleaning only source directories..${zishworkdir}" ; \
	zishworkdir=${zishworkdir} ; \
	find $$zishworkdir/* -type d -exec rm -rf {} \; ;


# ................................... standard insterface for the automake ..........................


all-am : all-custom-vars-am


install-am:  install-exec-zish-am


# check  (Automake manual definition:  Execute the test suite if any
check-am: check-custom-am check-results-am


# clean (Automake manual definition: Erase from the build tree the files built by make all.
clean-am: clean-custom-am
	@echo "clean :  Erase from the build tree the files built by make all. " ;


# distclean (Automake manual definition: "Additionally erase anything ./configure created."
distclean-am : distclean-custom-am
	@echo "distclean :  Additionally erase anything ./configure created ( ex: dirs in ${zishworkdir}/* ) " ;


# uninstall (Automake manual definition: "The opposite of make install: erase the installed files"
uninstall-am: uninstall-custom-am

