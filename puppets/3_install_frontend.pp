#*******************************************************************************
# E.S.O. - VLT project
#
# "@(#) $Id: 0_config_network.sh 39237 2017-09-30 23:29:04Z epena $"
#
# Script to reproduce svn server v1.8 problem with big files
#
# who        when        what
# ---------  ----------  ----------------------------------------------
# epena      2017-10-01  Absolute paths changed by relatives one
#

$grafana_dir = ['/data/grafana',]
$kibana_dir = ['/data/kibana/','/data/kibana/config','/data/kibana/data','/data/kibana/logs',]
$kairosdb_dir = ['/data/kairosdb','/data/kairosdb/conf','/data/kairosdb/log',]

file { $grafana_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  #source => '../config/grafana',
  #recurse => true,
  #replace => true,
}


file { $kibana_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

file { 'grafana_db':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  source => '/root/DATALAB/dains/config/grafana.db',
  path => '/data/grafana/grafana.db',
  replace => true,
}

file { 'kibana_yml':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  source => '/root/DATALAB/dains/config/kibana.yml',
  path => '/data/kibana/config/kibana.yml',
  replace => true,
}

file { $kairosdb_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
#  source => './kairosdb',
#  recurse => true,
#  replace => true,
}

file { kairosdb_conf:
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  source => '/root/DATALAB/dains/config/kairosdb_conf',
  path => '/data/kairosdb/conf/kairosdb.yml',
  recurse => true,
  replace => true,
}

docker_compose { 'dc_frontend':
  name=> '/root/DATALAB/dains/config/dc_frontend.yml',
  ensure  => present,
  require => [File[$grafana_dir], File[grafana_db], File[$kibana_dir], File[kibana_yml], File[$kairosdb_dir], File[kairosdb_conf]],
}
