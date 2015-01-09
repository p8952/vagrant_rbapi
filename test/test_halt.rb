require_relative 'minitest_helper'

class TestHalt < MiniTest::Unit::TestCase
	def test_up_halt_destroy
		assert_equal('not created', @@vagrant.status)

		assert_equal("0", @@vagrant.up)
		assert_equal('running', @@vagrant.status)

		assert_equal("0", @@vagrant.halt)
		assert_equal('poweroff', @@vagrant.status)

		assert_equal("0", @@vagrant.destroy)
		assert_equal('not created', @@vagrant.status)
	end

	def test_up_halt_halt_destroy
		assert_equal('not created', @@vagrant.status)

		assert_equal("0", @@vagrant.up)
		assert_equal('running', @@vagrant.status)

		assert_equal("0", @@vagrant.halt)
		assert_equal('poweroff', @@vagrant.status)

		assert_raises(VagrantRbapi::BoxNotRunning) { @@vagrant.halt }
		assert_equal('poweroff', @@vagrant.status)

		assert_equal("0", @@vagrant.destroy)
		assert_equal('not created', @@vagrant.status)
	end
end
