# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemfile_next_auto_sync/version'

Gem::Specification.new do |spec|
  spec.name          = 'gemfile_next_auto_sync'
  spec.version       = GemfileNextAutoSync::VERSION
  spec.authors       = ['Volodymyr Lapan']
  spec.email         = ['vlapan@zoolatech.com']

  spec.summary       = 'Keep Gemfile.lock and Gemfile_next.lock in sync'
  spec.description   = 'Keep Gemfile.lock and Gemfile_next.lock in sync,
    but it does not do any magic to actually change the running Ruby version or install the gems in the environment you are not currently running,
    it simply tells Bundler which Ruby and gem versions to use in its resolution algorithm and keeps the lock files in sync.'
  spec.homepage      = "https://github.com/zeuslocker/gemfile_next_auto_sync"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = "https://github.com/zeuslocker/gemfile_next_auto_sync"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
