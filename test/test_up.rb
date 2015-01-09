require_relative 'minitest_helper'

class TestUp < MiniTest::Unit::TestCase
	def test_up_up_destroy
		assert_equal('not created', @@vagrant.status)
		assert_equal("0", @@vagrant.up)
		assert_equal('running', @@vagrant.status)
		assert_equal("0", @@vagrant.destroy)
		assert_equal('not created', @@vagrant.status)
	end

	def test_up_up_up_destroy
		assert_equal('not created', @@vagrant.status)
		assert_equal("0", @@vagrant.up)
		assert_equal('running', @@vagrant.status)
		assert_raises(VagrantRbapi::BoxAlreadyRunning) { @@vagrant.up }
		assert_equal("0", @@vagrant.destroy)
		assert_equal('not created', @@vagrant.status)
	end
end
