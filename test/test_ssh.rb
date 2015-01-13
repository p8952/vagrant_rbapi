require_relative 'minitest_helper'

class TestSSH < MiniTest::Unit::TestCase
	def setup
		precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'test/precise64')
		@vagrant = Vagrant_Rbapi.new(precise64)
	end

	def teardown
		@vagrant.destroy if @vagrant.status != 'not created'
		Dir.chdir('../..')
	end

	def test_up_ssh_destroy
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		assert_includes(@vagrant.ssh('cat /etc/lsb-release'), 'Ubuntu 12.04 LTS')
		assert_equal('I am a Box', @vagrant.ssh('echo "I am a Box"'))
		assert_nil(@vagrant.ssh('sudo shutdown -h now'))

		sleep 5 while @vagrant.status == 'running'
		assert_equal('poweroff', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end
end
