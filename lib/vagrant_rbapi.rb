require 'vagrant_rbapi/version'
require 'vagrant_rbapi/exceptions'

require 'net/ssh'
require 'open3'

class Vagrant_Rbapi
	def initialize(vagrant_environment)
		Dir.chdir(vagrant_environment)
	end

	def vagrant_bin
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |dir|
			if File.executable?(File.join(dir, 'vagrant'))
				return File.join(dir, 'vagrant')
			end
		end
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
		status = out[/default(.*)\(/, 1].strip
		return status
	end

	def up
		raise VagrantRbapi::BoxAlreadyRunning if self.status == 'running'
		out, err, val = vagrant_cmd(['up'])
		return val
	end

	def ssh_config
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		out, err, val = vagrant_cmd(['ssh-config'])
		hostname = out[/HostName (.*)$/, 1].strip
		user = out[/User (.*)$/, 1].strip
		port = out[/Port (.*)$/, 1].strip
		identityfile = out[/IdentityFile (.*)$/, 1].strip
		return hostname, user, port, identityfile
	end

	def ssh(cmd)
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		config = ssh_config
		return Net::SSH.start(config[0], config[1], port: config[2], key_data: [File.read(config[3])]) do |ssh|
			ssh.exec!(cmd)
		end
	end

	def halt
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		out, err, val = vagrant_cmd(['halt', '--force'])
		return val
	end

	def destroy
		raise VagrantRbapi::BoxNotCreated if self.status == 'not created'
		out, err, val = vagrant_cmd(['destroy', '--force'])
		return val
	end
end
