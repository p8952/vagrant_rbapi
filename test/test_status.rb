require_relative 'minitest_helper'

class TestWhich < MiniTest::Unit::TestCase
	def test_status_fresh_up_halt_destroy
		assert_equal 'not created', @@vagrant.status
		assert_equal '0', @@vagrant.up
		assert_equal 'running', @@vagrant.status
		assert_equal '0', @@vagrant.halt
		assert_equal 'poweroff', @@vagrant.status
		assert_equal '0', @@vagrant.destroy
		assert_equal 'not created', @@vagrant.status
	end
end
