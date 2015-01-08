lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant_rbapi/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant_rbapi"
  spec.version       = VagrantRbapi::VERSION
  spec.authors       = ["Peter Wilmott"]
  spec.email         = ["p@p8952.info"]
  spec.summary       = %q{vagrant_rbapi}
  spec.description   = %q{vagrant_rbapi}
  spec.homepage      = ""
  spec.license       = "GPL3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
