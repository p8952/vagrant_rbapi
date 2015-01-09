require_relative 'minitest_helper'

class TestSSH < MiniTest::Unit::TestCase
	def test_up_ssh_destroy
		assert_equal('not created', @@vagrant.status)

		assert_equal("0", @@vagrant.up)
		assert_equal('running', @@vagrant.status)

		assert_equal(nil, @@vagrant.ssh('sudo shutdown -h now'))
		sleep 5 while @@vagrant.status == 'running'
		assert_equal('poweroff', @@vagrant.status)

		assert_equal("0", @@vagrant.destroy)
		assert_equal('not created', @@vagrant.status)
	end
end
