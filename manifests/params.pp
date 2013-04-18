# Class: pam::params
#
# This class defines default parameters used by the main module class pam
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to pam class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class pam::params {

  ### Application related parameters

  $config_dir = $::operatingsystem ? {
    default => '/etc/pam.d',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/pam.conf',
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

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $audit_only = false
  $noops = false

}
