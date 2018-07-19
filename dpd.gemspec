# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dpd_api/version'

Gem::Specification.new do |spec|
  spec.name          = "dpd"
  spec.version       = DPDApi::VERSION
  spec.authors       = ["Bloom & Wild"]
  spec.email         = ["dev@bloomandwild.com"]

  spec.summary       = "Wrapper for DPD's SOAP API"
  spec.description   = "Wrapper for DPD's SOAP API"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "savon", "~> 2.11"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "httpclient", "~> 2.8.3"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "dotenv"

  # testing
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
end
