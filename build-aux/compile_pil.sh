#! /bin/bash

compile_tcl()
{
echo "compile_tcl: begin "
test -e $prefix/lib/libtcl8.5.so && return 0
if [[ -n $dir_src_tcl && -d $dir_src_tcl ]];then
	cd $dir_src_tcl/unix
		SPECIFIC_OPTS=" --prefix=$prefix --exec-prefix=$prefix --libdir=$libdir --includedir=$includedir "
		 ./configure $SPECIFIC_OPTS $PLATFORM_OPTIONS  
		  cp ./Makefile ./Makefile.tcl.bkp
		  make &&	 make install
fi
echo "compile_tcl: end"
}

compile_tk()
{
echo "compile_tk: begin "
test -e $prefix/lib/libtk8.5.so && return 0
if [[ -n $dir_src_tk && -d $dir_src_tk ]];then
	cd $dir_src_tk/unix
		SPECIFIC_OPTS=" --prefix=$prefix --exec-prefix=$prefix --libdir=$libdir --includedir=$includedir "
		 ./configure $SPECIFIC_OPTS $PLATFORM_OPTIONS 
		cp ./Makefile ./Makefile.tk.bkp
		  make	&& 	make install
fi
echo "compile_tk: end "
}


compile_pil()
{
echo "compile_pil: begin "
test -e "$zishpythonsitedir/PIL.pth" && return 0 
echo "$zishpythonsitedir/PIL.pth"

if [[ -n $dir_src_pil &&  -d $dir_src_pil ]]; then
	cd $dir_src_pil
	freetype_path="$freetype_path_lib $freetype_path_inc"
	jpeg_path="$jpeg_path_lib $jpeg_path_inc"
	tiff_path="$tiff_path_lib $tiff_path_inc"
	zlib_path="$zlib_path_lib $zlib_path_inc"
	tcl_path="$tcl_path_lib $tcl_path_inc"
	freetype_path=$(echo $freetype_path | awk '{ for(i=1;i<NF+1;i++) gsub(/.*/,"& \\, ",$i) ; print $0 }' )
	jpeg_path=$(echo $jpeg_path | awk '{ for(i=1;i<NF+1;i++) gsub(/.*/,"& \\, ",$i) ; print $0 }' )
	tiff_path=$(echo $tiff_path | awk '{ for(i=1;i<NF+1;i++) gsub(/.*/,"& \\, ",$i) ; print $0 }' )
	zlib_path=$(echo $zlib_path | awk '{ for(i=1;i<NF+1;i++) gsub(/.*/,"& \\, ",$i) ; print $0 }' )
	tcl_path=$(echo $tcl_path | awk   '{ for(i=1;i<NF+1;i++) gsub(/.*/,"& \\, ",$i) ; print $0 }' )
	sed $sed_opts  '{  s,^FREETYPE_ROOT[ 	]\+=[ 	]\+None,FREETYPE_ROOT='"$freetype_path"',g ; 
			 s,^JPEG_ROOT[ 	]\+=[ 	]\+None,JPEG_ROOT='"$jpeg_path"',g ;
			 s,^TIFF_ROOT[ 	]\+=[ 	]\+None,TIFF_ROOT='"$tiff_path"',g ; 
			 s,^ZLIB_ROOT[ 	]\+=[ 	]\+None,ZLIB_ROOT='"$zlib_path"',g ; 
			 s,TCL_ROOT[ 	]\+=[ 	]\+None,TCL_ROOT='"$tcl_path"',g ;
			 s,^\([ 	]*\)library_dirs[ 	]*=[ 	]*\[.*\],\1library_dirs = ['"$libraries"'],g ;
			 s,^\([ 	]*\)include_dirs[ 	]*=[ 	]*\[.*\],\1include_dirs = ['"$includes"'],g ; } ' setup.py > setup.py.pil.tmp
		 cp ./setup.py ./setup.py.pil.bkp &&  cp ./setup.py.pil.tmp ./setup.py
		   $BUILDPYTHON setup.py build_ext -i 
		   $BUILDPYTHON selftest.py
		   $BUILDPYTHON setup.py install  
fi
echo "compile_pil : end"
}
 
