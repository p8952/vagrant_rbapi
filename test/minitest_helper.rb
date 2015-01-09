require 'minitest/autorun'
require_relative '../lib/vagrant_rbapi'

precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), '/test/precise64')
@@vagrant = Vagrant_Rbapi.new(precise64)
@@vagrant.destroy if @@vagrant.status != 'not created'
