#! /bin/bash


function get_distro()
{
echo "get_distro: begin..."
LOWER='abcdefghijklmnopqrstuvwxyz'
UPPER='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
distros="ubuntu vector slackware debian redhat arch suse gentoo conectiva mandriva mandrake pardus kanotix generic-undetected"
distro_file=$(ls /etc/{*version,*release} 2>/dev/null || echo "none")

if [[  x"$distro_file" = x"none" ]];then
	echo "get_distro: /proc/version approach"
	distro_file=$(cat /proc/version ||  echo "none" )
elif [[  x"$distro_file" = x"none" ]];then
	echo "get_distro: binary lbs_release approach"
	distro_file="generic-undetected" # at the moment..
elif [[  x"$distro_file" = x"none" ]];then
	echo "get_distro: binary gcc --version approach"
	distro_file="generic-undetected" # at the moment ..
fi
distro_file=$(echo $distro_file | sed '{ y/'$UPPER'/'$LOWER'/ ;  s/[ 	$)#(,.:]*//g ; }' )
distribution="generic-undetected"
for distro in $distros ; do
	i=$(expr match "$distro_file" ".*$distro" || true )
	if [[ $i -gt 0 ]];then
		distribution=$distro	
	fi
done
echo "get_distro: found $distribution . End"
}


function distro_tunning()
{
echo "distro_tunning: begin.. "
if [[ -n $distro_type ]];then
	echo "distro_tunning: already set $distro_type "
	#return 0;
fi

case $distribution in
redhat|mandriva)
	sed_opts=""
	find_opts=""
	awk_opts=""
	distro_type="rpm"
;;
debian)
	sed_opts=" --posix "
	find_opts=""
	awk_opts=""
	distro_type="debian"
;;
*)
	sed_opts=""
	find_opts=""
	awk_opts=""
    distro_type=""
;;
esac
echo "distro_tunning: for $distro_type "
echo "sed options: " $sed_opts
echo "find options:" $find_opts
echo "awk options: " $awk_opts
echo "distro_tunning: end.. "
}

function load_and_expand()
{
# @params  input_file output_file [vars_file]
# in the input file , variables we want to expand must be in the form ${VAR},  
# to difference them from the others $VAR we want to let them be
# It' s not a good idea to use ASCII codes because this codes can change depending the encoding, page code or language
Q="'"		 #  token="\"   ( ASCII code \x27 )
D="\$"	     #  token="$"   ( ASCII code \x24 )
TI="@"		 #  token="@"   ( ASCII code \x40 )
TF="@"		 #  token="@"   ( ASCII code \x40 )
CI="{"		 #  curly="{"   ( ASCII code \x7B )
CF="}"       #  curly="}"   ( ASCII code \x7D )
#TOKEN="#{"  #  token="#{"  ( ASCII code \x23\x7B )  his will substitute variables of the form #{VAR} to ${VAR}
if [[ -n $1 && -n $2 ]]; then
	if [ -e $3 ];then
	 . $3  # dot "." means same than "source"
	fi
	eval echo -ne $(cat -E $1 | sed $sed_opts ' {  s/^/'$Q'/g ;  s/$/'$Q'/g  ; s/'$TI'\([a-zA-Z0-9_]\+\)'$TF'/'$Q$D$CI'\1'$CF$Q'/g ; } ' ) | \
    sed $sed_opts "s,\(\$ \|\$$\),\n,g" >$2      # this last step fails in some old sed versions because they can not put the  \n replacement.
else 
	echo -e "Usage $0 : INPUT_FILE OUPUT_FILE  [VAR_FILES ] 
			 (vars must be in the form \${VAR})"
fi
}

function get_missing()
{
# Consider use custom configurations for apt or urpmi to download the pkgs.
echo "get_missing: begin... $missing_libs"
if [[ -z $missing_libs ]] ; then 
	echo "get_missing: no missing libraries " 
	return 0
elif [[ -z $distribution ]] ; then 
	echo "get_missing: no distribution detected " 
	return 1
fi
pkg="@----------@"
tmpdir=${abs_top_srcdir}/src/tmp
if [[ -d $tmpdir ]];then
	cd $tmpdir
	case $distribution in
	ubuntu|debian)
		URL_PKG=""
		sys_pkgs="gcc gcc-c++ build-essential automake nonexistent"
		lib_pkgs="zlib libjpeg libfreetype libreadline libtool zlib1g-dev libjpeg62-dev libfreetype6-dev libreadline5-dev"
		dev_pkgs="libldap2-dev libssl-dev libsasl2-dev python-ldap python-libxml2 python-libxslt1 python-mysqldb libmysql++-dev python-beautifulsoup"
		spec_pkgs=""
		pkgs="$sys_pkgs $lib_pkgs $dev_pkgs $spec_pkgs"
		comm_get_pkg="apt-get install -d -o=Dir::Cache::archives=$tmpdir $pkg"
		comm_ext_pkg="ar -m $pkg data.tar.gz | tar -xzvf -C $tmpdir"
	;;
	redhat)
		URL_PKG=""
		sys_pkgs="gcc gcc-c++ build-essential automake"
		lib_pkgs="libtool zlib1g-dev libjpeg62-dev libfreetype6-dev libreadline5-dev"
		dev_pkgs="libldap2-dev libssl-dev libsasl2-dev python-ldap python-libxml2 python-libxslt1 python-mysqldb libmysql++-dev python-beautifulsoup"
		spec_pkgs=""
		pkgs="$sys_pkgs $lib_pkgs $dev_pkgs $spec_pkgs"
		comm_get_pkg="up2date"
		comm_ext_pkg="$RPM2CPIO $pkg | $CPIO -i --make-directories --no-absolute-filenames --preserve-modification-time -v "

	;;
	*)
		URL_PKG=""
		sys_pkgs="gcc gcc-c++ build-essential automake"
		lib_pkgs="zlib libjpeg libfreetype libreadline libtool zlib1g-dev libjpeg62-dev libfreetype6-dev libreadline5-dev"
		dev_pkgs="libldap2-dev libssl-dev libsasl2-dev python-ldap python-libxml2 python-libxslt1 python-mysqldb libmysql++-dev python-beautifulsoup"
		spec_pkgs=""
		pkgs="$sys_pkgs $lib_pkgs $dev_pkgs $spec_pkgs"
		comm_get_pkg="yum "
		comm_ext_pkg="$RPM2CPIO $pkg | $CPIO -i --make-directories --no-absolute-filenames --preserve-modification-time -v "
	;;
	esac

	for lib in $missing_libs; do
	 	for pkg in $pkgs; do
			echo "get_missing : trying to get $lib from $pkg "
			j=$(expr match $pkg ".*$lib")
			if [[ $j -gt 0 ]];then	
				comm_get=$(echo $comm_get_pkg | sed $sed_opts 's/@[-]\{10,10\}@/'$pkg'/g')
				comm_ext=$(echo $comm_ext_pkg | sed $sed_opts 's/@[-]\{10,10\}@/'$pkg'/g')
				echo "get_missing : trying to get $lib for $distribution .. with $comm_get"
				#$comm_get_pkg
				#$comm_ext_pkg
				#rm ${tmpdir}/$pkg && mv ${tmpdir}/* ${prefix}
			fi
		done
	done
fi
echo "get_missing: end "
}


