require "bundler/gem_tasks"

task default: 'test'
task :test do
	test_path = File.join(File.expand_path(File.dirname(__FILE__)), '/test/test_*.rb')
	Dir.glob(File.join(test_path)) { |f| require f }
end
