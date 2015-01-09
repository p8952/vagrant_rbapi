require 'minitest/autorun'
require_relative '../lib/vagrant_rbapi'

class TestWhich < MiniTest::Unit::TestCase

	def test_which_with_vagrant_in_path
		vagrant = Vagrant_Rbapi.new('/')
		assert_equal `which vagrant`.strip, vagrant.vagrant_bin
	end
end
