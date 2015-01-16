require 'vagrant_rbapi/version'
require 'vagrant_rbapi/exceptions'

require 'net/scp'
require 'net/ssh'
require 'open3'

class Vagrant_Rbapi
	def initialize(vagrant_environment)
		Dir.chdir(vagrant_environment)
	end

	# Returns the full path of the 'vagrant' binary.
	def vagrant_bin
		ENV['PATH'].split(File::PATH_SEPARATOR).each do |dir|
			if File.executable?(File.join(dir, 'vagrant'))
				return File.join(dir, 'vagrant')
			end
		end
	end

	# Passes a command to vagrant. If vagrant returns zero, return stdout. If vagrant returns a non-zero, raise CommandReturnedNonZero.
	#
	# @param cmd [String] Passed directly to vagrant. Eg, status, up, halt, destroy.
	def vagrant_cmd(cmd)
		cmd = cmd.unshift(vagrant_bin).join(' ')
		out, err, val = '', '', ''
		Open3.popen3(ENV, cmd) do |stdin, stdout, stderr, wait_thr|
			out = stdout.read.to_s
			err = stderr.read.to_s
			val = wait_thr.value.to_s.split.last.to_i
		end
		raise VagrantRbapi::CommandReturnedNonZero unless val == 0
		return out
	end

	# Runs 'vagrant status' via {#vagrant_cmd}.
	#
	# @return [String] The formatted status string returned in stdout by 'vagrant status'. Eg, not created, running, powered off.
	def status
		out = vagrant_cmd(['status'])
		status = out[/default(.*)\(/, 1].strip
		return status
	end

	# Runs 'vagrant up' via {#vagrant_cmd}.
	#
	# @param cmd [String] An optional provider. Eg, aws. By default virtualbox is used as the provider.
	def up(provider = 'virtualbox')
		raise VagrantRbapi::BoxAlreadyRunning if self.status == 'running'
		vagrant_cmd(['up', "--provider=#{provider}"])
	end

	# Runs 'vagrant halt \-\-force' via {#vagrant_cmd}.
	def halt
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		vagrant_cmd(['halt', '--force'])
	end

	# Runs 'vagrant destroy \-\-force' via {#vagrant_cmd}.
	def destroy
		raise VagrantRbapi::BoxNotCreated if self.status == 'not created'
		vagrant_cmd(['destroy', '--force'])
	end

	# Query the ssh details of the running vagant box.
	# @return [String] The hostname of the box.
	# @return [String] The port used to access ssh on the box.
	# @return [String] The username of the non-root account on the box.
	# @return [String] The location of the private key used to authenticate.
	def ssh_config
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		out = vagrant_cmd(['ssh-config'])
		hostname = out[/HostName (.*)$/, 1].strip
		user = out[/User (.*)$/, 1].strip
		port = out[/Port (.*)$/, 1].strip
		identityfile = out[/IdentityFile (.*)$/, 1].strip
		return hostname, user, port, identityfile
	end

	def ssh(cmd)
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		config = ssh_config
		out = Net::SSH.start(config[0], config[1], port: config[2], key_data: [File.read(config[3])]) do |ssh|
			ssh.exec!(cmd)
		end
		out.strip! unless out.nil?
		return out
	end

	def scp(direction, recursive, source, destination)
		raise VagrantRbapi::BoxNotRunning if self.status != 'running'
		config = ssh_config
		if direction == :upload
			Net::SCP.start(config[0], config[1], port: config[2], key_data: [File.read(config[3])]) do |scp|
				scp.upload!(source, destination, recursive: recursive)
			end
		elsif direction == :download
			Net::SCP.start(config[0], config[1], port: config[2], key_data: [File.read(config[3])]) do |scp|
				scp.download!(source, destination, recursive: recursive)
			end
		end
	end
end
