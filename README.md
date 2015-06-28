# Puppet module: pam

## DEPRECATION NOTICE
This module is no more actively maintained and will hardly be updated.

Please find an alternative module from other authors or consider [Tiny Puppet](https://github.com/example42/puppet-tp) as replacement.

If you want to maintain this module, contact [Alessandro Franceschi](https://github.com/alvagante)


This is a Puppet module for pam
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-pam

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE 

* Use custom source directory for the whole /etc/pam.d/ directory

        class { 'pam':
          source_dir       => 'puppet:///modules/example42/pam/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Enable auditing without without making changes on existing pam configuration *files*

        class { 'pam':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'pam':
          noops => true
        }

* Use custom sources for /etc/pam.conf main config file 

        class { 'pam':
          source => [ "puppet:///modules/example42/pam/pam.conf-${hostname}" , "puppet:///modules/example42/pam/pam.conf" ], 
        }


* Use custom template for /etc/pam.conf main config file. Note that template and source arguments are alternative. 

        class { 'pam':
          template => 'example42/pam/pam.conf.erb',
        }

* Automatically include a custom subclass

        class { 'pam':
          my_class => 'example42::my_pam',
        }


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/example42/puppet-pam.png?branch=master" alt="Build Status" />}[https://travis-ci.org/example42/puppet-pam]
