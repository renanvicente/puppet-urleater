# Class: urleater::params
#
# This class defines default parameters used by the main module class urleater
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to urleater class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class urleater::params {

  ### Application related parameters


  $source = $::operatingsystem ? {
    default => 'https://github.com/renanvicente/urleater-get',
  }

  $dependencies = $::operatingsystem ? {
    default => 'git',
  }

  $service = $::operatingsystem ? {
    default => 'urleater-get',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/urleater-get.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $data_dir = $::operatingsystem ? {
    default => '/usr/local/src/urleater-get',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/urleater-get',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/urleater/urleater-get.log',
  }

  $port = '7777'

  $customer = 'default'
  $hostname = ''
  $vhost_directory = ''
  $server   = ''
  $revision = 'master'


  # General Settings
  $my_class = ''
  $template = 'urleater/urleater-get.conf.erb'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $noops = undef

}
