require 'vagrant_rbapi'

precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), '/test/gentoo-amd64')
vagrant = Vagrant_Rbapi.new(precise64)

puts vagrant.status
puts vagrant.destroy
