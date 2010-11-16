# ====================================== information of the package =============================
# the next 2 macros have to be the first ones in a autoconf script.
AC_PREREQ([2.0])  # no prerequisite version of autoconf for the moment.
AC_INIT([zish],[0.2],[adso.lists.pub@gmail.com],[zish],[http://www.free-instants.org/zish])
AC_COPYRIGHT([this software have license GPLv3])													


# it seems logical to configure autoconf dirs just after initilizing it and before automake (Automake manual)
# -- next macro create the dir and put into it the auxiliar scripts config.status config.guess install-sh
#    if we want autoconf to find other required auxliary script better copy into this directory before.
AC_CONFIG_MACRO_DIR(m4) # any other user defined m4 macro which aclocal must be aware of ?
# AC_CONFIG_SRCDIR(myfile) # check the existences of a file in the srcdir directory
AC_CONFIG_AUX_DIR(build-aux)

# ============================= platform and distro detection (have to be here) ==================	
AC_CANONICAL_HOST
AC_CANONICAL_BUILD
AC_CANONICAL_TARGET		# Have to go before automake am_init_automake ?
						# We can get the 32 or 64bit system information from here.


#------------------------------------------------------------------------------------------------#
# The aim of this package is to check if we have all requirements before to uncompress and compile 
# the individual packages.-----------------------------------------------------------------------

required_libs="z jpeg freetype readline"
required_headers=""
missing_libs=""
missing_headers=""

#------------------------------------------------------------------------------------------------#


# ============================ Initializing automake, pkg-config and related autotools ==============
AM_INIT_AUTOMAKE
#AM_GLIB_GNU_GETTEXT
#PKG_PROG_PKG_CONFIG


# starting to defining my own variable substitutions
AC_SUBST(AUTHOR)
AC_SUBST(VERSION)
AC_SUBST(LICENSE)
AC_SUBST(TARGET)
AC_SUBST(FIND)
AC_SUBST(WGET)
AC_SUBST(LDFLAGS_NONSTANDARD)
AC_SUBST(CPPFLAGS_NONSTANDARD)


# === installation directories
# prefix
# exec_prefix  # architecture dependent files
# sysconfdir
# bindir
# datadir
# datarootdir # defaults $(prefix)/share
# libdir
# includedir
# oldincludedir  # headers for NON gcc compilers 
#AC_SUBST(prefix)
#AC_SUBST(libdir)
#AC_SUBST(includedir)

# -- vars to appear in the install script.
AUTHOR=adso
LICENSE=GPL
USER=""
SP=":"
ROOT_PATH="/usr/sbin"$SP"/root/lib"
EXTRA_PATH=""
PATH=$PATH$SP$ROOT_PATH$SP$EXTRA_PATH
# Not only we set a different default prefix to don't try to install in a 
# forbidden locations in our shared hosting, futhermore we will warn the user
# if he / she pass a prefix out of the $HOME scope.
prefix_default=${HOME}/opt
AC_PREFIX_DEFAULT($prefix_default)
athome=$( expr index $prefix $HOME )
AS_IF([test x"$athome" != x"0" ],
	[AC_MSG_NOTICE([The prefix is set to --prefix=$prefix])],
	[AC_MSG_ERROR([This --prefix=$prefix can try to install in a forbidden location..])]
)

AC_ARG_ENABLE(plone4,--enable-plone4 preparing Plone 4 requirements see README , 
		[plonever=4
		 py_version_short=2.6],
        [plonever=3
        py_version_short=2.4]
)
AC_SUBST(plonever)

zishpythonlib=${prefix}/lib/python${py_version_short}
zishpythonsite=${prefix}/lib/python${py_version_short}/site-packages
zishpythondistutils=${prefix}/lib/python${py_version_short}/distutils
zishinstance=${prefix}/zopeservers
#this values are better set from the custom install script (install-zish.sh)
#zishinstancename=
#zishinstancelink=
#zishworkdir=
#zishtree=
#zishhtml=

#better to don't override AC_PROG_INSTALL nor INSTALL because it have a different meaning
ZISH_SCRIPT=build-aux/install-zish-0.2.sh
INSTALL_ZISH=build-aux/install-zish.sh 				 


AC_SUBST(USER)
AC_SUBST(HOME)  # It's necessary to export in this way env vars to makefiles ?
AC_SUBST(prefix)
AC_SUBST(ZISH_SCRIPT)
AC_SUBST(INSTALL_ZISH)
AC_SUBST(zishpythonlib)
AC_SUBST(zishpythonsite)
AC_SUBST(zishpythondistutils)
AC_SUBST(outputdir)


AC_ARG_ENABLE( distutils-home,--enable-distutils-home try to install with home approach , 
		[distutils_approach=home],
        [distutils_approach=prefix]
)
AS_IF([test x"$distutils_approach" == x"home"], 
	[distutilscfg=distutils_home.cfg.in],
	[distutilscfg=distutils_prefix.cfg.in]
)
AC_SUBST(distutilscfg)






#shell_pointer=/home/user/myvars.source
#AC_SUBST_FILE(shell_pointer) # to load all variables in a file.
TARGET=myvars.source



# my package dir structure #SUBDIR_DISTRIBUTE
#dir_config =./build-aux/input
#dir_input = ./build-aux/input

#   Guide script with macro for system requirement detections;
#   if any error , Makefile is not created.
#   -----------------------------------------------------------
# === checks for programs
AC_PROG_CC
AC_PROG_CPP  			# if this fails give up.
AC_PROG_CXX
AC_PROG_LN_S
AC_PROG_INSTALL  		# Allows to do  "make install"
AC_PROG_MAKE_SET
AC_PROG_AWK
AC_PROG_SED
AC_PROG_MKDIR_P
AC_PATH_PROG([TAR],[tar],[AC_MSG_ERROR([i can not find tar check the PATH])],[]) 	# tar is required
AC_PATH_PROG([FIND],[find],[AC_MSG_ERROR([i can not find find check the PATH])],[]) # find is required
AC_PATH_PROG([WGET],[wget],[AC_MSG_ERROR([i can not find wget check the PATH])],[]) # wget is required
AC_PATH_PROG([AR],[ar],[AC_MSG_WARN([i can not find ar, check the PATH])],[])  
AC_PATH_PROG([CPIO],[cpio],[AC_MSG_WARN([i can not find cpio, check the PATH])],[]) 
AC_PATH_PROG([DPKG],[dpkg],[AC_MSG_WARN([i can not find dpkg, check the PATH])],[]) 
AC_PATH_PROG([RPM],[rpm],[AC_MSG_WARN([i can not find wget rpm, the PATH])],[]) 
AC_PATH_PROG([RPM2CPIO],[rpm2cpio],[AC_MSG_WARN([i can not find rpm2cpio, check the PATH])],[$PATH]) 


# --- automake python related section 
#
#AM_PATH_PYTHON([version],[action-if-found],[:])   									 #Let's keep here for using in future.
#It creates the following output variables 
#AC_SUBST(PYTHON)
#AC_SUBST(PYTHON_VERSION)
#AC_SUBST(PYTHON_PLATFORM)
#AC_SUBST(PYTHON_prefix)
#AC_SUBST(PYTHON_EXEC_prefix)
#AC_SUBST(pythondir) 	# where the site-packages directory is
#AC_SUBST(pkgpythondir) # = pythondir/$(PKGDIR)
#AC_SUBST(pyexecdir)  	# c extensions are in this directory
#AC_SUBST(pkgpyexecdir)	# = pyexecdir/$(PKGDIR)
#AM_CONDITIONAL([HAVE_PYTHON], [test "$PYTHON" != :])

distro=""
distro_type=""
AC_MSG_CHECKING($host)
AS_CASE([$host_os],
	[*windows*],[echo "No windows"],
	[*linux*],[
		#AS_VAR_IF()
		AS_CASE([$distro], 
			[debian], 
			[
				echo "detected Debian"
				distro_type="deb"
			],
			[rpm], 
			[
			echo "detected RPM distro"
			distro_type="rpm"
			],
			[
			echo "Linux generic-undetected"
			distro_type=""
			])
	],
	[echo "Unknown platform"])
AC_SUBST(distro_type)
#AC_UNALIGNED_64_ACCESS


#AC_MSG_CHECKING([for build target])
#AM_CONDITIONAL(DARWIN,  test "$build_target" = "darwin")
#AM_CONDITIONAL(CYGWIN,  test "$build_target" = "cygwin")
#AM_CONDITIONAL(MINGW,   test "$build_target" = "mingw")
#AM_CONDITIONAL(SOLARIS, test "$build_target" = "solaris")
#AM_CONDITIONAL(XFREEBSD, test "$build_target" = "freebsd")
#AM_CONDITIONAL(OPENBSD, test "$build_target" = "openbsd")
#AM_CONDITIONAL(LINUX, test "$build_target" = "linux")
#AC_MSG_RESULT([$build_target])
#AC_SUBST(build_target)

# --- trick for libraries in not standard locations ---
LDFLAGS_NONSTANDARD=$(find / -maxdepth 3 \( -type d  -name lib -o -name lib32 -o -name lib64 \) -printf " -L%p " 2>/dev/null)
CPPFLAGS_NONSTANDARD=$(find / -maxdepth 3 \( -type d  -iname include \) -printf " -I%p " 2>/dev/null)
#PATH_NONSTANDARD=$(.. for any case we need to add some paths .. )


# === checks for libraries
# One problem in shared hostings is libraries placed in a not standard locations.
# Following the trick above we can pass the right variables CPPFLAGS, LDFLAGS and PATH to the ac macros.
# 1.- find most of the "lib" and "lib64" directories in the system ( if some outside this places.. sorry too bad. )
# 2.- give to the compiler (includes) and linker (libraries) flags

LIBS="$LIBS"
CFLAGS="$CFLAGS"
CPPFLAGS="$CPPFLAGS $CPPFLAGS_NONSTANDARD" 
LDFLAGS="$LDFLAGS $LDFLAGS_NONSTANDARD" 


# -- using pkg-config 
#   check for metadata .pc files located in ${prefix}/lib/pkgconfig  /usr/lib/pkgconfig and alikes
#   PROGRAM_CFLAGS and PROGRAM_LIB variables are set, and then this variables can be used in the Makefile.am script.
#   If any error in meeting this requirements Makefile won't be created.
#PKG_CHECK_MODULES(ZISH, zlib libjpeg libfreetype libreadline x11 , [[]])
#AC_SUBST(ZISH_CFLAGS)
#AC_SUBST(ZISH_LIBS)


# -- through autoconf functions
AC_MSG_CHECKING( for necessary libraries )
AC_CHECK_LIB([z],[main],[],[missing_libs="$missing_libs libz"],[])
AC_CHECK_LIB([jpeg],[main],[],[missing_libs="$missing_libs libjpeg"],[])
AC_CHECK_LIB([freetype],[main],[],[missing_libs="$missing_libs libfreetype"],[])
AC_CHECK_LIB([readline],[main],[],[missing_libs="$missing_libs libreadline"],[])
AC_CHECK_LIB([nonexistent],[main],[],[missing_libs="$missing_libs nonexistent"],[])


AC_SUBST(HAVE_LIBZ)
AC_SUBST(HAVE_LIBJPEG)
AC_SUBST(HAVE_LIBFREETYPE)
AC_SUBST(HAVE_LIBREADLINE)

AC_SUBST(LIBZ_CPPFLAGS)
AC_SUBST(LIBZ_LDFLAGS)

# -- using AM_PATH_xx macros
AC_PATH_X  #  after this function X_CFLAGS and X_LIBS variables are set
AC_SUBST(X_LIBS)
AC_SUBST(X_CFLAGS)
AC_SUBST(X_CPPFLAGS)

# AM_PATH_XML2  (2.4.0)   after this function XML_CPPFLAGS and XML_LIBS variables are set
AC_SUBST(XML2_LIBS)
AC_SUBST(XML2_CFLAGS)
AC_SUBST(XML2_CPPFLAGS)

AC_SUBST(AM_CPPLAGS)
AC_SUBST(AM_LDFLAGS)

AC_SUBST(missing_libs)


# === checks for types
AC_TYPE_INT64_T

# === checks for structures


# === checks for compiler characteristics



# === checks for library functions



# === checks for system services ===


# === checking for custom files  === 
# ... files that are required in the auxiliary directory.
#AC_REQUIRE_AUX_FILE(install-sh) 

# ... files that are required in the src dir
#AC_CHECK_FILES(zish-install-0.1.sh,[],[])
#AC_SUBST(HAVE_zish-install-0.1.sh)


# ... defining output files to create them... 
# ... Any of following files need a file.in with their same name expliciting which substitution are defined.
AC_CONFIG_HEADERS([config.h])


AC_CONFIG_FILES([Makefile])


AC_CONFIG_FILES([
	                output/altinstall.pth:config/common/altinstall.pth.in
					output/sitecustomize.py:config/common/sitecustomize.py.in
					output/sitevars:config/common/sitevars.in
					output/zish.pth:config/common/zish.pth.in
					output/zope_vhost:config/common/zope_vhost.in
					output/distutils_home.cfg:config/common/distutils_home.cfg.in
					output/distutils_prefix.cfg:config/common/distutils_prefix.cfg.in
					output/paster.cfg:config/common/paster.cfg.in
					output/readme:config/common/readme1.in:config/common/readme2.in
	        ])

AC_CONFIG_FILES([output/distutils.cfg:config/common/$distutilscfg])



AC_CONFIG_LINKS([$INSTALL_ZISH:build-aux/install-zish-0.2.sh],[],[])

#Let's GNU/make to move the above files to the right locations.

# the next macro have to be the last one in a autoconf script.
AC_OUTPUT
AC_MSG_NOTICE([********************************************************
zish is an script to install "Zope Into a Shared Hosting"
You can install zish in this machine with :
	make && make install
**************************************************************])
