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

	def test_scp
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		@vagrant.scp(:upload, false, File.expand_path('../files/Lorem.txt'), '/home/vagrant/Lorem.txt')
		assert_equal('/home/vagrant/Lorem.txt: ASCII text', @vagrant.ssh('file ~/Lorem.txt'))

		@vagrant.scp(:upload, false, File.expand_path('../files/Lorem.gif'), '/home/vagrant/Lorem.gif')
		assert_equal('/home/vagrant/Lorem.gif: GIF image data, version 89a, 125 x 125', @vagrant.ssh('file ~/Lorem.gif'))

		@vagrant.scp(:download, false, '/home/vagrant/Lorem.txt', File.expand_path('../files/Lorem2.txt'))
		assert_equal('../files/Lorem2.txt: ASCII text', `file ../files/Lorem2.txt`.strip)

		@vagrant.scp(:download, false, '/home/vagrant/Lorem.gif', File.expand_path('../files/Lorem2.gif'))
		assert_equal('../files/Lorem2.gif: GIF image data, version 89a, 125 x 125', `file ../files/Lorem2.gif`.strip)

		@vagrant.scp(:upload, true, File.expand_path('../files'), '/home/vagrant/')
		assert_equal('/home/vagrant/files/Lorem.txt: ASCII text', @vagrant.ssh('file ~/files/Lorem.txt'))
		assert_equal('/home/vagrant/files/Lorem.gif: GIF image data, version 89a, 125 x 125', @vagrant.ssh('file ~/files/Lorem.gif'))

		FileUtils.rm('../files/Lorem2.txt') if File.file?('../files/Lorem2.txt')
		FileUtils.rm('../files/Lorem2.gif') if File.file?('../files/Lorem2.gif')

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end

	def test_scp_recursive
		assert_equal('not created', @vagrant.status)

		@vagrant.up
		assert_equal('running', @vagrant.status)

		@vagrant.scp(:upload, true, File.expand_path('../files'), '/home/vagrant/')
		assert_equal('/home/vagrant/files/Lorem.txt: ASCII text', @vagrant.ssh('file ~/files/Lorem.txt'))
		assert_equal('/home/vagrant/files/Lorem.gif: GIF image data, version 89a, 125 x 125', @vagrant.ssh('file ~/files/Lorem.gif'))

		@vagrant.scp(:download, true, '/home/vagrant/files', File.expand_path('../files'))
		assert_equal('../files/files/Lorem.txt: ASCII text', `file ../files/files/Lorem.txt`.strip)
		assert_equal('../files/files/Lorem.gif: GIF image data, version 89a, 125 x 125', `file ../files/files/Lorem.gif`.strip)

		FileUtils.rm_r('../files/files') if File.directory?('../files/files')

		@vagrant.destroy
		assert_equal('not created', @vagrant.status)
	end
end
