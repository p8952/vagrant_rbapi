lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant_rbapi/version'

Gem::Specification.new do |spec|
	spec.name          = 'vagrant_rbapi'
	spec.version       = VagrantRbapi::VERSION
	spec.authors       = ['Peter Wilmott']
	spec.email         = ['p@p8952.info']
	spec.summary       = %q{Ruby bindings for interacting with Vagrant boxes}
	spec.description   = %q{Ruby bindings for interacting with Vagrant boxes}
	spec.homepage      = ''
	spec.license       = 'GPL3'

	spec.files         = `git ls-files -z`.split("\x0")
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ['lib']

	spec.add_development_dependency 'yard'

	spec.add_runtime_dependency 'net-scp'
	spec.add_runtime_dependency 'net-ssh'
	spec.add_runtime_dependency 'rake'
end
