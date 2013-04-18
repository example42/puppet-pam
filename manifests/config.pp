#
# = Define: pam::config
#
# This define manages single pam configation files
# It creates entries in /etc/pam.d
#
# == Parameters
#
# [*ensure*]
#   String. Default: present
#   Manages config presence. Possible values:
#   * 'present' - Creates the file with the provided content
#   * <path> - Creates a link to another file
#   * 'absent' - Stop service and remove package and managed files
#
# [*template*]
#   String. Default:''
#   Sets the path of a custom template to use as content of config
#   If defined, config file has: content => content("$template")
#   Example: template => 'site/pam/auth.erb',
#
# [*source*]
#   String. Default:''
#   Sets the source path of a custom file to use as content of config
#   If defined, config file has: source => $source,
#   Example: source => 'puppet:///modules/site/pam/auth',
#
# == Example
#
# pam:::config { 'login':
#   source => 'puppet:///modules/site/pam/login',
# }
#
define pam::config (
  $ensure   = present,
  $template = '' ,
  $source   = '' ,
  $ensure   = present ) {

  include pam

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  file { "pam_config_${name}":
    ensure  => $ensure,
    path    => "${pam::config_dir}/${name}",
    mode    => $pam::config_file_mode,
    owner   => $pam::config_file_owner,
    group   => $pam::config_file_group,
    content => $manage_file_content,
    source  => $manage_file_source,
    replace => $pam::file_replace,
    audit   => $pam::file_audit,
    noop    => $pam::noops,
  }

}
