#!/usr/bin/env ruby

require 'vagrant_rbapi'

vagrant = Vagrant_Rbapi.new('/root/gentoo-amd64')

vagrant.status
vagrant.up
vagrant.status
vagrant.ssh_config
vagrant.halt
vagrant.status
vagrant.destroy
vagrant.status
