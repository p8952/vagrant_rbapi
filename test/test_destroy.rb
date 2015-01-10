require_relative 'minitest_helper'

class TestDestroy < MiniTest::Unit::TestCase
	def setup
		precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'test/precise64')
		@vagrant = Vagrant_Rbapi.new(precise64)
	end

	def teardown
		@vagrant.destroy if @vagrant.status != 'not created'
		Dir.chdir('../..')
	end

	def test_up_destroy
		assert_equal('not created', @vagrant.status)

		assert_equal('0', @vagrant.up)
		assert_equal('running', @vagrant.status)

		assert_equal('0', @vagrant.destroy)
		assert_equal('not created', @vagrant.status)
	end

	def test_up_destroy_destroy
		assert_equal('not created', @vagrant.status)

		assert_equal('0', @vagrant.up)
		assert_equal('running', @vagrant.status)

		assert_equal('0', @vagrant.destroy)
		assert_equal('not created', @vagrant.status)

		assert_raises(VagrantRbapi::BoxNotCreated) { @vagrant.destroy }
		assert_equal('not created', @vagrant.status)
	end
end
