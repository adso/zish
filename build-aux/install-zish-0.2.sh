#! /bin/bash 

#You can change this  at your own risk
URLS_SRC_PLONE3="http://www.python.org/ftp/python/2.4.6/Python-2.4.6.tar.bz2 \
http://prdownloads.sourceforge.net/tcl/tcl8.5.7-src.tar.gz \
http://prdownloads.sourceforge.net/tcl/tk8.5.7-src.tar.gz \
http://effbot.org/downloads/Imaging-1.1.6.tar.gz \
http://www.xmlsoft.org/sources/python/libxml2-python-2.6.15.tar.gz \
http://www.zope.org/Products/Zope/2.11.3/Zope-2.11.3-final.tgz \
http://www.free-instants.org/downloads/zish/pcgi.tar.gz \
http://www.free-instants.org/downloads/zish/config.tar.gz \
http://peak.telecommunity.com/dist/ez_setup.py"

#You can change this versions at your own risk for Plone 4
URLS_SRC_PLONE4="http://www.python.org/ftp/python/2.6.6/Python-2.6.6.tar.bz2 \
http://prdownloads.sourceforge.net/tcl/tcl8.5.7-src.tar.gz \
http://prdownloads.sourceforge.net/tcl/tk8.5.7-src.tar.gz \
http://effbot.org/downloads/Imaging-1.1.6.tar.gz \
http://www.xmlsoft.org/sources/python/libxml2-python-2.6.15.tar.gz \
http://pypi.python.org/packages/source/Z/Zope2/Zope2-2.13.0a3.zip \
http://www.free-instants.org/downloads/zish/pcgi.tar.gz \
http://www.free-instants.org/downloads/zish/config.tar.gz \
http://peak.telecommunity.com/dist/ez_setup.py"

#URLS_SRC_LOCAL="http://localhost/downloads/src/zish/Python-2.4.6.tar.bz2 \
#http://localhost/downloads/src/zish/tcl8.5.7-src.tar.gz \
#http://localhost/downloads/src/zish/tk8.5.7-src.tar.gz \
#http://localhost/downloads/src/zish/Imaging-1.1.6.tar.gz \
#http://localhost/downloads/src/zish/libxml2-python-2.6.15.tar.gz \
#http://localhost/downloads/src/zish/Zope-2.11.3-final.tgz \
#http://localhost/downloads/src/zish/pcgi.tar.gz \
#http://localhost/downloads/src/zish/config.tar.gz \
#http://localhost/downloads/src/zish/ez_setup.py"


abs_builddir=${abs_builddir:-$PWD}

# Autoconf connection ?
# Most of this variables can be sourced from the makefile execution
 if test -e $abs_builddir/zish.vars ;then
		echo "sourcing zish variables from $abs_builddir "
		source $abs_builddir/zish.vars   #... or not
		distutilscfg=$(echo | awk -v var=$distutilscfg '{ gsub(".in","",var) ; print var }' )
        echo "distutils file is $distutilscfg "
 else
    echo "zish.vars not found in abs_builddir: " $abs_builddir
    exit 1
fi

plonever=${plonever:-"3"}
case $plonever in
"3")
    py_version_short=${py_version_short:-"2.4"}           
    PLONE_VERSION="3.2.1"                               
    ZOPE_VERSION="2.11.3"      
    URLS_SRC="$URLS_SRC_PLONE3"
    zishinstancename="zish_instance3"
    buildoutver=${buildoutver:-"bconf/buildoutsProd"} 
;;
"4")
    py_version_short=${py_version_short:-"2.6"}            
    PLONE_VERSION="4.0rc1"   
    ZOPE_VERSION="2.12.10"   
    URLS_SRC="$URLS_SRC_PLONE4"
    zishinstancename="zish_instance4"
    buildoutver=${buildoutver:-"bconf/buildoutsProd4"} 
;;
*)
  echo "Plone version not found "
  exit 1
;;
esac

distutilscfg=${distutilscfg:-"none"}
prefix=${prefix:-"$HOME/opt"}
ZISHRC=${ZISHRC:-"$HOME/.zishrc"}
ROOT_PATH=${ROOT_PATH:-"/sbin:/usr/sbin"}
PATH=${PATH:-"$prefix/bin:$PATH:$ROOT_PATH"}
PATH_NONSTANDARD=${PATH_NONSTANDARD:-"/  /lib  /usr  /root  $prefix"}
abs_top_builddir=${abs_top_builddir:-$PWD}
abs_top_srcdir=${abs_top_srcdir:-"$PWD"}
abs_builddir=${abs_builddir:-$PWD}
FILE_LOG=$abs_builddir/install.log
ERROR_LOG=$abs_builddir/errors.log

zishworkdir="$abs_top_srcdir/src"
zishtemplatesdir="$abs_top_srcdir/config/"    
zishconfigdir="$abs_builddir/output"          
zishinstancesdir="$prefix/var/zopeservers/instances"
zishinstancedir="$zishinstancesdir/$zishinstancename"
zisheggs="$prefix/var/zopeservers/packages/eggs"
zishpkg="$prefix/var/zopeservers/packages/downloads"
zishhtmldir="$HOME/public_html/$zishinstancename"
zishpythonlibdir=${prefix}/lib/python${py_version_short}  
zishpythonsitedir=$zishpythonlibdir/site-packages
zishpythondistutilsdir=$zishpythonlibdir/distutils

# where the package will install their own libraries and includes 
libdir=${libdir:-"$prefix/lib"}  # i use it later in -rpath , todo should be nice to detect lib or lib64
includedir=${includedir:-"$prefix/include"}

CPPFLAGS=$(find / -maxdepth 3 \( -type d  -iname include \) -printf " -I%p " 2>/dev/null)
LDFLAGS=$(find / -maxdepth 3 \( -type d  -name lib -o -name lib32 -o -name lib64 \) -printf "-L%p " 2>/dev/null) 
includes=$( echo $CPPFLAGS | awk ' { for(i=1;i<=NF;i++)  gsub(/-I/,"",$i) gsub(/.*/,"\"&\"\\, ",$i) ; print } ' )
libraries=$( echo $LDFLAGS | awk ' { for(i=1;i<=NF;i++)   gsub(/-L/,"",$i) gsub(/.*/,"\"&\"\\, ",$i) ; print } ' )

zlib_path_lib=$(find $PATH_NONSTANDARD  -maxdepth 3  \( -iname "libz.so" \) -printf "\"%h\" " 2>/dev/null | cut -f1 -d" " )
zlib_path_inc='"'$prefix'/include"'     #   "zlib.h"
jpeg_path_lib=$(find $PATH_NONSTANDARD  -maxdepth 3  \( -iname "libjpeg*.so"  \) -printf "\"%h\" " 2>/dev/null | cut -f1 -d" " )
jpeg_path_inc='"'$prefix'/include"'     #   "jpeglib.h"
freetype_path_lib=$(find $PATH_NONSTANDARD -maxdepth 3  \( -iname "libfreetype*.so" \) -printf "\"%h\" " 2>/dev/null | cut -f1 -d" "  )
freetype_path_inc='"'$prefix'/include"' #   "freetype.h"
tiff_path_lib=$(find $PATH_NONSTANDARD  -maxdepth 3  \( -iname "libtiff*.so" \) -printf "\"%h\" " 2>/dev/null | cut -f1 -d" "  )
tiff_path_inc='"'$prefix'/include"'     #   "tiff.h"
tcl_path_lib=$(find $PATH_NONSTANDARD   -maxdepth 3  \( -iname "libtcl*.so"  \) -printf "\"%h\" " 2>/dev/null | cut -f1 -d" "   )
tcl_path_inc='"'$prefix'/include"'      #   "tcl.h"  no muestran versiones


HEADING="#---zish---"
PYTHONHOME=$prefix
PYTHONPATH=$zishpythonsitedir
BUILDPYTHON=$prefix/bin/python
BUILDPASTER=$prefix/bin/paster

DIR_TREE={$prefix/srv,$prefix/tmp/{build,lib,scripts},$zishinstancedir,$zisheggs,$zishpkg,$zishhtmldir}

pid_fifo=0


prepare_account()
{
echo "prepare_account: begin.. "
cat > $ZISHRC <<_EOF_
 $HEADING
 PREFIX=$prefix
 PATH=$prefix/bin:\$PATH
 LD_LIBRARY_PATH=$prefix/lib:$prefix/lib64
 export PATH LD_LIBRARY_PATH
_EOF_

PROFILE=$(ls $HOME/.bash_profile 2>/dev/null || \
         ls $HOME/.bash_login  2>/dev/null  || \
         ls $HOME/.profile 2>/dev/null || \
            { touch $HOME/.profile ;   echo "$HOME/.profile" ; true ; } )

token=$(grep -l "zish" $PROFILE || true )
	if [[ -z $token ]];then
		echo -e "prepare_account : updating profile $PROFILE ..."
		echo "source \$HOME/.zishrc" >> $PROFILE
	fi
tree_done=$(eval ls $DIR_TREE &>/dev/null || echo 1)
test -n $tree_done && eval mkdir -p $DIR_TREE 
	if test -d $zishconfigdir ; then
		echo "prepare_account : directory of config files $zishconfigdir "
		cp -Ru $zishtemplatesdir/* $zishconfigdir/          
		# trying to do it everything relative  buiddir
		load_and_expand $zishconfigdir/$buildoutver/htaccess.in $zishhtmldir/.htaccess none
		load_and_expand $zishconfigdir/$buildoutver/Zope.cgi.in $zishhtmldir/Zope.cgi none 
        chmod +x $zishhtmldir/Zope.cgi
	fi
source $ZISHRC
echo " prepare_account : end "	
}


extract_downloads(){
for item in $URLS_SRC ; do
    file_name=$(basename $item)
    file_path=$zishworkdir/$file_name
    uncompress_archive $file_path $zishworkdir
done
}

check_dirs()
{
echo "check_dirs : begin .... "
shopt -u failglob
dir_src_python=$(find $zishworkdir -maxdepth 1 -type d -iname python-${py_version_short}*) 
dir_src_tcl=$(find $zishworkdir -maxdepth 1 -type d -iname tcl* )  
dir_src_tk=$(find $zishworkdir -maxdepth 1 -type d -iname tk* )  
dir_src_pil=$(find $zishworkdir -maxdepth 1 -type d -iname imaging* )  
dir_src_xml2=$(find $zishworkdir -maxdepth 1 -type d -iname libxml2-python* )  
dir_src_zope=$(find $zishworkdir -maxdepth 1 -type d -iname Zope?${ZOPE_VERSION}* )  
dir_src_pcgi=$(find $zishworkdir -maxdepth 1 -type d -iname pcgi* ) 
shopt -s failglob
echo "check_dirs : end. "
}


 	
compile_xml2()
{
echo "compile_xml2: begin "
test -e $prefix/lib/python2.4/xml && return 0
if [[ -n $dir_src_xml2 && -d $dir_src_xml2 ]]; then
	cd $dir_src_xml2
		SPECIFIC_OPTS=
		sed $sed_opts ' {
		 s,\(^[ 	]*includes_dir[ 	]*=[ 	]*\[\)\(.*$\),\1'"$includes"'\2,g ; 
		 s,\(^[ 	]*libdirs[ 	]*=[ 	]*\[\)\(.*$\),\1'"$libraries"'\2,g ;  } ' ./setup.py > ./setup.py.xml.tmp 
		cp ./setup.py ./setup.py.xml.bkp && cp ./setup.py.xml.tmp ./setup.py 
		  $BUILDPYTHON setup.py build_ext -i
		  $BUILDPYTHON setup.py install
fi
echo "compile_xml2: end "
}


compile_zope_standalone()
{
echo "compile_zope_standalone "
test -e "$prefix/bin/pcgi-wrapper" && return 0
if [[ -d $dir_src_zope && -x $BUILDPYTHON ]]; then
	cd $dir_src_zope
	SPECIFIC_OPTS=" --prefix=$prefix --with-python=$BUILDPYTHON "
	 ./configure $SPECIFIC_OPTS  # you must supply either home or prefix, no both  ?? system distutils should not globally define "prefix"
	  make && make install
	# Whith persistent 
	if [[ -d $dir_src_pcgi ]]; then
		cd $dir_src_pcgi
		SPECIFIC_OPTS=" --prefix=$prefix  --exec-prefix=$prefix --libdir=$libdir --includedir=$includedir " 
		 ./configure  $PLATFORM_OPTIONS $SPECIFIC_OPTS 
		  make && make install
          cp pcgi_publisher.py $prefix/bin/pcgi_publisher.py
	fi
fi
}


install_setuptools()
{
echo "install_setuptools: begin... "
if test -x $BUILDPYTHON ; then
	echo "install_setuptools: entering in :" $BUILDPYTHON 
	test -e "$zishpythonsitedir/setuptools*egg"  || $BUILDPYTHON "$zishworkdir/ez_setup.py" #can fail if Cheetah or other eggs doesn't find headers  
	test -e  "$zishpythonsitedir/ZopeSkel*egg" ||   $prefix/bin/easy_install ZopeSkel
	test -e  "$zishpythonsitedir/virtualenv*egg" ||  $prefix/bin/easy_install virtualenv
		if test -d $zishinstancesdir; then
			cd $zishinstancesdir
			echo "install_setuptools: entering in :" $zishinstancesdir
			load_and_expand $zishconfigdir/$buildoutver/paster.cfg.in $zishinstancesdir/paster.cfg none
			$BUILDPASTER create --no-interactive -t plone3_buildout --config=paster.cfg $zishinstancename
			if test -d $zishinstancedir ; then
				cd $zishinstancedir 
				echo "install_setuptools: entering in :" $zishinstancedir				
				#zc.buildout creates the directories relatives to the configuration file (buildout.cfg) 
				#finding a way to set a temporary directory to easy_install without raising a SandBoxViolation error.
				load_and_expand $zishconfigdir/$buildoutver/buildoutB.cfg.in  $zishinstancedir/buildoutB.cfg none
				load_and_expand $zishconfigdir/$buildoutver/buildoutT.cfg.in  $zishinstancedir/buildoutT.cfg none
				load_and_expand $zishconfigdir/$buildoutver/versions-${PLONE_VERSION}.cfg.in $zishinstancedir/versions-${PLONE_VERSION}.cfg none
				load_and_expand $zishconfigdir/$buildoutver/versions-Zope-${ZOPE_VERSION}.cfg.in $zishinstancedir/versions-Zope-${ZOPE_VERSION}.cfg none
				$BUILDPYTHON ./bootstrap.py -c buildoutT.cfg
				./bin/buildout -c buildoutT.cfg
				load_and_expand $zishconfigdir/$buildoutver/zope.conf.in $zishinstancedir/parts/instance/etc/zope.conf none
				test -x ./bin/instance &&  ./bin/instance start
			else
				echo "install_setuptools : ERROR instance directory does not exist."
			fi
		else
			echo "install_setuptools : ERROR instances directories does not exist."
		fi
fi
echo "install_setuptools: end."
}

do_make()
{
if [[ $(expr $distutilscfg : '.*'prefix ) -gt 0 ]];then
	echo "Trying to install with prefix strategy "
	ALTINST=" --prefix=$prefix "
elif [[ $(expr $distutilscfg : '.*'home ) -gt 0 ]];then
	echo "Trying to install with home/install-base strategy "
	ALTINST=" --home=$prefix "
else
	echo "Error assigning distutils.cfg file"
	exit 1
fi 
check_distro
distro_tunning
prepare_account
#get_missing
get_sources 
check_dirs
}


do_make_install()
{

if [[ $(expr $distutilscfg : '.*'prefix ) -gt 0 ]];then
	echo "Trying to install with prefix strategy "
	ALTINST=" --prefix=$prefix "
elif [[ $(expr $distutilscfg : '.*'home ) -gt 0 ]];then
	echo "Trying to install with home/install-base strategy "
	ALTINST=" --home=$prefix "
else
	echo "Error assigning distutils.cfg file"
	exit 1
fi 
prepare_account
check_distro
check_downloads "$URLS_SRC" "$zishworkdir" 
extract_downloads
distro_tunning
#get_missing
check_dirs
compile_tcl
compile_tk
compile_python
compile_xml2
compile_pil
compile_zope_standalone
install_setuptools
}



tests()
{
echo "tests: $(basename $0) test suite"
echo "tests: begin ... "
echo "tests: prefix is :		   :"   $prefix
echo "tests: abs_top_builddir is   :"   $abs_top_builddir
echo "tests: abs_top_srcdir is	   :"   $abs_top_srcdir
echo "tests: zishworkdir is		   :"   $zishworkdir
echo "tests: distutils approach is :"   $distutilscfg   #${distutilscfg%.in} only in Debian.
echo "tests: PLATFORM_OPTIONS      :" 	$PLATFORM_OPTIONS
echo "tests: LDFLAGS:"    $LDFLAGS
echo "tests: CPPFLAGS:"   $CPPFLAGS
check_distro
distro_tunning
#prepare_account
#get_missing
#get_sources
check_dirs
echo "tests: distro seems: " $distribution
echo "tests:python version :" ${py_version_short}
echo "tests:Plone version :" ${PLONE_VERSION}
echo "tests:Zope version :" ${ZOPE_VERSION}
echo "tests: src dir for python created :" $dir_src_python
echo "tests: src dir for zope created :" $dir_src_zope
#load_and_expand $zishconfigdir/$buildoutver/zope.conf.in $zishinstancedir/parts/instance/etc/zope.conf none
echo "tests: end "
}



usage()
{
cat <_EOF_
Usage : $(basename $0) 
	do-make 		: 
	do-make-install :
	tests			:
_EOF_
}


# ............................................................................................
ERROR_LOG=/dev/null


function onexit(){
	local exit_status=${1:-$?}
	local ERROR=""
	if [[ $exit_status -gt 0 ]]; then
            ERROR="ERROR"
	fi
	echo "$0 : $ERROR onexit exiting with estatus: $exit_status"
     	clearErrOptions && die
	exit $exit_status
}

function onbreak(){
	local exit_status=${1:-$?}
	local ERROR=""
	if [[ $exit_status -gt 0 ]]; then
            ERROR="ERROR"
	fi
	echo "$0 : $ERROR onbreak exiting with estatus: $exit_status"
        break
	clearErrOptions && die
}


function setErrOptions()
{
	echo "$0 : setting error options"
	set -o errexit
	set -o errtrace
    	set -o nounset
	set -o posix
	#set -o pipefail
	#shopt -s failglob
	#trap onexit HUP INT TERM ERR 
	#trap onbreak HUP INT TERM ERR # la segunda machaca la primera. 
	trap onbreak ERR # la segunda machaca la primera. 

}

function clearErrOptions()
{
# This function reset all the error handling options to do not affect 
# the system environment after this script execution
	echo "$0 : cleaning error options"
	set +o errexit
	set +o nounset
	set +o errtrace
	set +o posix
        #set +o pipefail
	#shopt -u failglob
	trap - ERR
}

function die()
{
   rm pipe || true

}

# llamada al script ..........................................
setErrOptions
while true;
do 
    echo "$0 : main loop "
    # my commands ...    
    . $abs_top_srcdir/build-aux/common_functions.sh
    . $abs_top_srcdir/build-aux/compile_python.sh
    . $abs_top_srcdir/build-aux/compile_pil.sh
    case "$1" in 
	    do-make)
	    do_make   2>&1 | tee $FILE_LOG
	    ;;
	    do-make-install)
	    tests &> $FILE_LOG
	    do_make_install 2>&1 | tee -a $FILE_LOG
	    ;;
	    tests)
	    tests 2> $ERROR_LOG 
	    ;;
	    *)
	    usage
     	;;
    esac
    # ..............................
    break
done 
clearErrOptions && die
echo "$0 : end"
