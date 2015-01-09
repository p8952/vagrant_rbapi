Vagrant Rbapi
=============

Installation
------------

    gem install vagrant_rbapi

Usage
-------
    irb(main):001:0> require 'vagrant_rbapi'
    => true
    irb(main):002:0> vagrant = Vagrant_Rbapi.new('test/precise64')
    => #<Vagrant_Rbapi:0x000000007d5140>
    irb(main):003:0> vagrant.status
    => "not created"
    irb(main):004:0> vagrant.up    
    => "0"
    irb(main):005:0> vagrant.status
    => "running"
    irb(main):006:0> vagrant.ssh('uname -a')
    => "Linux precise64 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux"
    irb(main):007:0> vagrant.halt
    => "0"
    irb(main):008:0> vagrant.status
    => "poweroff"
    irb(main):009:0> vagrant.destroy
    => "0"
    irb(main):010:0> vagrant.status
    => "not created"
