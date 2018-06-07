# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "iframe_gdpr/version"

Gem::Specification.new do |spec|
  spec.name          = "iframe_gdpr"
  spec.version       = IframeGDPR::VERSION
  spec.authors       = ["René Sprotte"]
  spec.summary       = %q{Use IFRAMES in compliance to the EU General Data Protection Regulation (GDPR) requirements in your Ruby on Rails applications.}
  spec.homepage      = "http://github.com/renspr/iframe_gdpr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.0"

  spec.add_dependency "railties", ">= 5.0.0", "< 6.0"
end
