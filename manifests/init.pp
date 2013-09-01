# = Class: pam
#
# This is the main pam class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, pam class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $pam_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, pam main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $pam_source
#
# [*source_dir*]
#   If defined, the whole pam configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $pam_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $pam_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, pam main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $pam_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $pam_options
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $pam_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in pam::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include pam"
# - Call pam as a parametrized class
#
# See README for details.
#
#
class pam (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits pam::params {

  $config_file_mode=$pam::params::config_file_mode
  $config_file_owner=$pam::params::config_file_owner
  $config_file_group=$pam::params::config_file_group

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_audit = $pam::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $pam::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $pam::source ? {
    ''        => undef,
    default   => $pam::source,
  }

  $manage_file_content = $pam::template ? {
    ''        => undef,
    default   => template($pam::template),
  }

  ### Managed resources
  file { 'pam.conf':
    ensure  => present,
    path    => $pam::config_file,
    mode    => $pam::config_file_mode,
    owner   => $pam::config_file_owner,
    group   => $pam::config_file_group,
    source  => $pam::manage_file_source,
    content => $pam::manage_file_content,
    replace => $pam::manage_file_replace,
    audit   => $pam::manage_audit,
    noop    => $pam::noops,
  }

  # The whole pam configuration directory can be recursively overriden
  if $pam::source_dir {
    file { 'pam.dir':
      ensure  => directory,
      path    => $pam::config_dir,
      source  => $pam::source_dir,
      recurse => true,
      purge   => $pam::bool_source_dir_purge,
      force   => $pam::bool_source_dir_purge,
      replace => $pam::manage_file_replace,
      audit   => $pam::manage_audit,
      noop    => $pam::noops,
    }
  }


  ### Include custom class if $my_class is set
  if $pam::my_class {
    include $pam::my_class
  }

}
