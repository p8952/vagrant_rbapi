require_relative 'minitest_helper'

class TestHalt < MiniTest::Unit::TestCase
	def setup
		precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'test/precise64')
		@vagrant = Vagrant_Rbapi.new(precise64)
	end

	def teardown
		@vagrant.destroy if @vagrant.status != 'not created'
		Dir.chdir('../..')
	end

	def test_halt
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		@vagrant.halt
		assert_equal('poweroff', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end

	def test_halt_halt
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		@vagrant.halt
		assert_equal('poweroff', @vagrant.status)

		assert_raises(VagrantRbapi::BoxNotRunning) { @vagrant.halt }
		assert_equal('poweroff', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end
end
