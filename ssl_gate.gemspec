Gem::Specification.new do |s|
  s.name        = 'ssl_gate'
  s.version     = '0.0.2'
  s.date        = '2018-03-28'
  s.executables << 'ssl_gate'
  s.summary     = 'SSL Proxy'
  s.description = ''
  s.authors     = ['Artyom B']
  s.email       = 'author@email.address'
  s.files       = Dir['{bin,lib}/**/*']
  s.homepage    = 'http://rubygems.org/gems/ssl-gate'
  s.license     = 'Nonstandard' # http://spdx.org/licenses

  s.add_runtime_dependency 'em-http-request'
  s.add_runtime_dependency 'eventmachine'
  s.add_runtime_dependency 'thin'
  s.add_development_dependency 'rake'
end
# http://guides.rubygems.org/make-your-own-gem
# gem build ssl_gate.gemspec
# gem install ./ssl_gate-0.0.0.gem
# curl -u gempusher https://rubygems.org/api/v1/api_key.yaml > .credentials; chmod 0600 ~/.gem/credentials
# gem push ssl_gate-0.0.0.gem
# gem list -r ssl_gate
# chmod a+x bin/do_dfs