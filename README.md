# Puppet module: urleater

This is a Puppet module for urleater based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Renan Vicente

Official site: http://www.renanvicente.com

Official git repository: http://github.com/renanvicente/puppet-urleater

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.


Urleater is a script to get the urls that is enabled in Apache or Nginx.

Project Url:

Client: https://github.com/renanvicente/urleater-get
Server: https://github.com/renanvicente/urleater-server

## CHANGELOG

**Version 0.0.4**
- Add git dependency

## USAGE - Basic management

* Install urleater with normal settings

        class { 'urleater':
          server => 'www.renanvicente.com',
          port   => '7777',
          customer => 'renanvicente',
         }


* Install urleater with default settings

        class { 'urleater':
          server => 'www.renanvicente.com',
          port   => '7777',
         }

* Install using a specific hostname to add in urleater-server

        class { 'urleater':
          server => 'www.renanvicente.com',
          port   => '7777',
          customer => 'renanvicente',
          hostname => 'host.renanvicente.com',
         }

* Install using a specific directory to search for urls or more than one directory

        class { 'urleater':
          server => 'www.renanvicente.com',
          port   => '7777',
          customer => 'renanvicente',
          vhost_directory => ['/etc/nginx/conf.d','/etc/nginx/sites-enabled'],
         }

* Install a specific version of urleater package

        class { 'urleater':
          server => 'www.renanvicente.com',
          port   => '7777',
          version => '1.0',
        }

* Disable urleater service.

        class { 'urleater':
          disable => true
        }

* Remove urleater package

        class { 'urleater':
          absent => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'urleater':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'urleater':
          template => 'urleater/urleater-get.conf.erb',
        }

* Automatically include a custom subclass

        class { 'urleater':
          my_class => 'urleater::my_urleater',
        }


## CONTINUOUS TESTING

[![Build Status](https://travis-ci.org/renanvicente/puppet-urleater.svg?branch=master)](https://travis-ci.org/renanvicente/puppet-urleater)
