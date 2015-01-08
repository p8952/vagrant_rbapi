require "vagrant_rbapi/version"

require 'mkmf'
require 'open3'

class Vagrant_Rbapi
	def initialize(vagrant_environment)
		Dir.chdir(vagrant_environment)
	end

	def vagrant_bin
		find_executable('vagrant')
	end

	def vagrant_cmd(cmd)
		cmd = cmd.unshift(vagrant_bin).join(' ')
		out, err, val = '', '', ''
		Open3.popen3(ENV, cmd) do |stdin, stdout, stderr, wait_thr|
			out = stdout.read.to_s
			err = stderr.read.to_s
			val = wait_thr.value.to_s.split.last
		end
		return out, err, val
	end

	def status
		out, err, val = vagrant_cmd(['status'])
		puts out
		puts err
		puts val
	end

	def up
		out, err, val = vagrant_cmd(['up'])
		puts out
		puts err
		puts val
	end

	def ssh_config
		out, err, val = vagrant_cmd(['ssh-config'])
		puts out
		puts err
		puts val
	end

	def halt
		out, err, val = vagrant_cmd(['halt', '--force'])
		puts out
		puts err
		puts val
	end

	def destroy
		out, err, val = vagrant_cmd(['destroy', '--force'])
		puts out
		puts err
		puts val
	end
end
