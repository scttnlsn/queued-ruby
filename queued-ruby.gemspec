$:.push File.expand_path('../lib', __FILE__)

require 'queued/version'

Gem::Specification.new do |spec|
  spec.name = 'queued-ruby'
  spec.version = Queued::VERSION
  spec.files = Dir.glob('**/*')
  spec.require_paths = ['lib']
  spec.summary = 'Queued client library'
  spec.description = 'Queued client library for Ruby'
  spec.authors = ['Scott Nelson']
  spec.email = 'scott@scttnlsn.com'
  spec.homepage = 'https://github.com/scttnlsn/queued-rb'

  spec.add_dependency 'faraday', ['>= 0.8', '< 0.10']
  spec.add_dependency 'faraday_middleware', ['>= 0.8', '< 0.10']
  spec.add_dependency 'multi_json', ['~> 1.0']
  spec.add_dependency 'json', ['~> 1.7'] if RUBY_VERSION < '1.9'

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('webmock')
end