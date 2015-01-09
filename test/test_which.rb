require_relative 'minitest_helper'

class TestWhich < MiniTest::Unit::TestCase
	def test_which_with_vagrant_in_path
		assert_equal `which vagrant`.strip, @@vagrant.vagrant_bin
	end
end
