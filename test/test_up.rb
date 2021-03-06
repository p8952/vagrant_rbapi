require_relative 'minitest_helper'

class TestUp < MiniTest::Unit::TestCase
	def setup
		precise64 = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'test/precise64')
		@vagrant = Vagrant_Rbapi.new(precise64)
	end

	def teardown
		@vagrant.destroy if @vagrant.status != 'not created'
		Dir.chdir('../..')
	end

	def test_up
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end

	def test_up_up
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		assert_raises(VagrantRbapi::BoxAlreadyRunning) { @vagrant.up }
		assert_equal('running', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end

	def test_up_vbox
		assert_equal('not created', @vagrant.status)

		@vagrant.up('virtualbox')
		assert_equal('running', @vagrant.status)

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end

	def test_up_foobar
		assert_equal('not created', @vagrant.status)

		assert_raises(VagrantRbapi::CommandReturnedNonZero) { @vagrant.up('foobar') }
		assert_equal('not created', @vagrant.status)
	end
end
