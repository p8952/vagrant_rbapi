require "bundler/gem_tasks"

task default: 'test'
task :test do
	Dir.glob('./test/test_*.rb') { |f| require f }
end
