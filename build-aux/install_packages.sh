#! /bin/bash

# First we need a basic developement system that is ready by default in most cases.
BASIC_SYSTEM_PACKAGES="gcc gcc-c++ build-essential automake libtool zlib1g-dev libbz2-dev.libjpeg62-dev libfreetype6-dev libreadline6-dev"

# this software have many dependencies so we install them first
BASIC_SOFTWARE_DEPENS="lynx pdftohtml xsltproc tidy gs-common catdoc xpdf-utils xpdf wv xlhtml ppthtml unrtf htmldoc pstotext"   

# In case we want to make our life easy compiling python ( imaging, ldap, .. ) and zope, better to install this:
# Of course we can download the source-code of every package instead.
BASIC_PACKAGES_DEVEL="python2.4-dev tk-dev tcl-dev python-imaging libldap2-dev libssl-dev libsasl2-dev \
                      python-ldap python-libxml2 python-libxslt1 python-mysqldb libmysql++-dev python-beautifulsoup"

# Now the specific packages we could need 
BASIC_PACKAGES_PRODUCTION="apache2 apache2-dev"

for pkg in $BASIC_SYSTEM_PACKAGES $BASIC_SOFTWARE_DEPENS $BASIC_PACKAGES_DEVEL; do
	echo "Searching for $pkg"
	if `dpkg -s $pkg | grep -iqE "install(.*)ok"`;then
		echo "$pkg installed"	
	else
		apt-cache search ^"$pkg"$
		apt-get install -d --yes $pkg
	fi
done

# if the admin group doesnt exit , create it
# if the zope user doesn't exist , create it
# then disable (lock ) the root account 
# addgroup --system admin
# adduser -G admin --system zope
# sudo passwd -l root


