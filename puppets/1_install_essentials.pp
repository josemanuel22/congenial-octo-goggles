#*******************************************************************************
# E.S.O. - VLT project
#
# "@(#) $Id: 0_config_network.sh 39237 2017-09-30 23:29:04Z epena $"
#
# Script to reproduce svn server v1.8 problem with big files
#
# who        when        what
# ---------  ----------  ----------------------------------------------
# epena      2017-10-01  This header added
#


class { 'docker':
  root_dir => '/vlt/docker',
}

class {'docker::compose': 
  ensure => present,
  install_path => '/bin',
}

# Create directories
# 777 is temporal, must be checked

file { '/diskb/data':
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

file { '/data':
  ensure => link,
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
  target => '/diskb/data',
}

file { '/data/portainer':
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => '0777',
}

docker::run { 'portainer':
  image   => 'portainer/portainer',
  #volumes => ['/data/portainer/docker.sock:/var/run/docker.sock', '/data/portainer/portainer-data:/data'],
  volumes => ['/var/run/docker.sock:/var/run/docker.sock', '/data/portainer/portainer-data:/data'],
  ports => ['10001:9000'],
  require => File['/data/portainer'],
}


#install netdata
include wget

wget::fetch { 'fetch netdata':
    source      => 'https://my-netdata.io/kickstart-static64.sh',
    destination => './kickstart-static64.sh',
}

exec { 'run netdata':
    command => '/bin/bash  ./kickstart-static64.sh --non-interactive',
}








