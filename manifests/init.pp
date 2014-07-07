# = Class: urleater
#
# This is the main urleater class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, urleater class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $urleater_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, urleater main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $urleater_source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, urleater main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $urleater_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $urleater_options
#
# [*service_autorestart*]
#   Automatically restarts the urleater service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $urleater_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $urleater_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $urleater_disableboot
#
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in urleater::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*service*]
#   The name of urleater service
#
# [*service_status*]
#   If the urleater service init script supports status argument
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The port to connect to urleater server.
#
# [*customer*]
#
# The field customer to insert into urleater server.
#
# [*hostname*]
#
# hostname that will be going to be insert into urleater server.
#
# [*vhost_directory*]
#
# Directory where urleater-get will search for urls.
#
# [*revision*]
#
# The revision git.
#
# [*server*]
#
# The urleater server address.
#
# See README for usage patterns.
#
class urleater (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $template            = params_lookup( 'template' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $noops               = params_lookup( 'noops' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  $customer            = params_lookup( 'customer' ),
  $hostname            = params_lookup( 'hostname' ),
  $vhost_directory     = params_lookup( 'vhost_directory' ),
  $server              = params_lookup( 'server' ),
  $absent              = params_lookup( 'absent' ),
  $port                = params_lookup( 'port' ),
  $revision            = params_lookup( 'revision' ),
  ) inherits urleater::params {

  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)

  ### Definition of some variables used in the module
  $manage_package = $urleater::bool_absent ? {
    true  => 'absent',
    false => $urleater::version,
  }

  $manage_service_enable = $urleater::bool_disableboot ? {
    true    => false,
    default => $urleater::bool_disable ? {
      true    => false,
      default => $urleater::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $urleater::bool_disable ? {
    true    => 'stopped',
    default =>  $urleater::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $urleater::bool_service_autorestart ? {
    true    => Service[$urleater::service],
    false   => undef,
  }

  $manage_file = $urleater::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_file_source = $urleater::source ? {
    ''        => undef,
    default   => $urleater::source,
  }

  $manage_file_content = $urleater::template ? {
    ''        => undef,
    default   => template($urleater::template),
  }

  ### Managed resources
  vcsrepo { $urleater::service:
    ensure    => $urleater::manage_package,
    provider  => git,
    noop      => $urleater::noops,
    source    => $urleater::source,
    revision  => $urleater::revision,
    path      => $urleater::data_dir,
    notify    => Exec["$urleater::data_dir/install_nix.sh"],
  }

  exec { "$urleater::data_dir/install_nix.sh":
    path    => ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
    require => Vcsrepo[$urleater::data_dir],
    refreshonly => true,
  }

  service { $urleater::service:
    ensure     => $urleater::manage_service_ensure,
    name       => $urleater::service,
    enable     => $urleater::manage_service_enable,
    hasstatus  => $urleater::service_status,
    pattern    => $urleater::process,
    require    => Exec["$urleater::data_dir/install_nix.sh"],
    noop       => $urleater::noops
  }

  file { $urleater::config_file:
    ensure  => $urleater::manage_file,
    path    => $urleater::config_file,
    mode    => $urleater::config_file_mode,
    owner   => $urleater::config_file_owner,
    group   => $urleater::config_file_group,
    require => Exec["$urleater::data_dir/install_nix.sh"],
    notify  => $urleater::manage_service_autorestart,
    content => $urleater::manage_file_content,
    noop    => $urleater::noops,
  }


  ### Include custom class if $my_class is set
  if $urleater::my_class {
    include $urleater::my_class
  }



}
