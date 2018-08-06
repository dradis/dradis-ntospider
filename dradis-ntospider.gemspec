$:.push File.expand_path('../lib', __FILE__)
require 'dradis/plugins/appspider/version'
version = Dradis::Plugins::APPSpider::VERSION::STRING


# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name = 'dradis-appspider'
  spec.version = version
  spec.summary = 'APPSpider add-on for the Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse output produced from the APPSpider Web Vulnerability Scanner (Rapid 7) into Dradis.'

  spec.license = 'GPL-2'

  spec.authors = ['Michael Gargiullo']
  spec.email = ['michael.gargiullo@pivotpointsecurity.com']
  spec.homepage = 'http://dradisframework.org'

  spec.files = `git ls-files`.split($\)
  spec.executables = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})

  # By not including Rails as a dependency, we can use the gem with different
  # versions of Rails (a sure recipe for disaster, I'm sure), which is needed
  # until we bump Dradis Pro to 4.1.
  # s.add_dependency 'rails', '~> 4.1.1'
  spec.add_dependency 'dradis-plugins', '~> 3.6'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
