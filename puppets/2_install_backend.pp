#*******************************************************************************
# E.S.O. - VLT project
#
# "@(#) $Id: 0_config_network.sh 39237 2017-09-30 23:29:04Z epena $"
#
# Script to reproduce svn server v1.8 problem with big files
#
# who        when        what
# ---------  ----------  ----------------------------------------------
# epena      2017-09-17  This header added
#


# Create directories
$datalake_dir = ['/data/datalake',]
$elasticsearch_dir = ['/vlt/elasticsearch', '/vlt/elasticsearch/data', '/vlt/elasticsearch/log', '/vlt/elasticsearch/config', ]
$cassandra_dir = ['/data/cassandra', '/data/cassandra/data', '/data/cassandra/config','/data/cassandra/log','/data/cassandra/saved_caches',]

file { $datalake_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

file { $elasticsearch_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

file { 'elasticsearch_yml':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  source => '/root/DATALAB/dains/config/elasticsearch.yml',
  path => '/vlt/elasticsearch/config/elasticsearch.yml',
  #replace => true,
}

file { $cassandra_dir:
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

file { '/root/DATALAB/dains/config/cassandra.yaml':
  ensure => 'file',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  path => '/data/cassandra/config/cassandra.yaml'
}

exec { 'host_memory_conf_elasticsearch': #Operacion idempotente
  path => "/usr/sbin/",
	command => 'sysctl -w vm.max_map_count=262144'
}

#Running docker back-end
docker_compose { 'dc_backend':
  name=> '/root/DATALAB/dains/config/dc_backend.yml',
  ensure  => present,
  require => [File[$datalake_dir],File[$elasticsearch_dir],File[$cassandra_dir], File[elasticsearch_yml]],
  }
