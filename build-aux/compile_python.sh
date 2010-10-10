#! /bin/bash

compile_python()
{
# Python does not support related environment variables (PYTHONPATH, ..) while compiling.
echo "compile_python: begin in " $dir_src_python
if [[ -n $dir_src_python && -d $dir_src_python ]];then
 		cd $dir_src_python
		#load_and_expand $zishconfigdir/$buildoutver/$distutilscfg  $dir_src_python/Lib/distutils/distutils.cfg  none # Not supported so soon ?.
        #LDFLAGS+=' , -Wl, -rpath=\$$LIB:'$prefix'/lib ' # use with care i think could be better LD_RUN_PATH="$LD_RUN_PATH" or LD_LIBRARY_PATH In .zish
		SPECIFIC_OPTS=" --prefix=$prefix --exec-prefix=$prefix --libdir=$libdir --includedir=$includedir --enable-unicode=ucs4 --with-pth " 
		CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS"  ./configure  $SPECIFIC_OPTS  $PLATFORM_OPTIONS 
		cp ./Makefile Makefile.python.bkp 
		  make && make install
		# This is important because dependent code needs to find Python.h and other headers	
		cp $dir_src_python/Include/* $prefix/include/python${py_version_short}
 		if [[ -n $zishpythonlibdir &&  -d $zishpythonlibdir ]]; then
			 load_and_expand $zishconfigdir/$buildoutver/altinstall.pth.in 	$zishpythonlibdir/site-packages/altinstall.pth none  
			 load_and_expand $zishconfigdir/$buildoutver/zish.pth.in		$zishpythonlibdir/site-packages/zish.pth none   
			 load_and_expand $zishconfigdir/$buildoutver/$distutilscfg.in 	$zishpythonlibdir/distutils/distutils.cfg none  
			 load_and_expand $zishconfigdir/$buildoutver/sitecustomize.py.in  $zishpythonlibdir/site-packages/sitecustomize.py none  
            #TOLEARN: any conflict with .pth files ?
		fi
	which python
fi
echo "compile_python: end "
}

