require_relative 'minitest_helper'

class TestSSHConfig < MiniTest::Unit::TestCase
	def setup
		precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'test/precise64')
		@vagrant = Vagrant_Rbapi.new(precise64)
	end

	def teardown
		@vagrant.destroy if @vagrant.status != 'not created'
		Dir.chdir('../..')
	end

	def test_ssh_config
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		assert_equal('127.0.0.1', @vagrant.ssh_config[0])
		assert_equal('vagrant', @vagrant.ssh_config[1])
		assert_equal('2222', @vagrant.ssh_config[2])
		assert_equal(File.join(File.expand_path('~/'), '.vagrant.d/insecure_private_key'), @vagrant.ssh_config[3])
		
		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end
end
