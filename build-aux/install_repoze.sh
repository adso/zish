

repoze_index="http://dist.repoze.org/bfg/current/simple"
virtualenv --no-site-packages $zishinstancedir
$zishinstancedir/bin/easy_install -i $repoze_index repoze.bfg
