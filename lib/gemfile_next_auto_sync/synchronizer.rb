# frozen_string_literal: true
require 'pry'

module GemfileNextAutoSync
  class Synchronizer < Bundler::Plugin::API
    def setup
      check_bundler_version
      opt_in
    end

    private

    def check_bundler_version
      self.class.hook('before-install-all') do
        next if Bundler::VERSION >= '1.17.0' || !GEMFILE_NEXT_LOCK.exist?

        Bundler.ui.warn(<<-EOM.gsub(/\s+/, ' '))
          GemfileNextAutoSync can't automatically update the Gemfile_next.lock because you are running
          an older version of Bundler.
          Update Bundler to 1.17.0 to discard this warning.
        EOM
      end
    end

    def opt_in
      self.class.hook('before-install-all') do
        binding.pry
        @previous_lock = Bundler.default_lockfile.read
      end

      self.class.hook('after-install-all') do
        binding.pry
        current_definition = Bundler.definition
        next_definition = Bundler::Definition.build(GEMFILE_NEXT, GEMFILE_NEXT_LOCK, unlock)

        next if !GEMFILE_NEXT_LOCK.exist? ||
          nothing_changed?(current_definition)

        update!(current_definition)
      end
    end

    def nothing_changed?(current_definition)
      current_definition.to_lock == @previous_lock
    end

    def update!(current_definition)
      binding.pry
      lock = which_lock
      Bundler.ui.confirm("Updating the #{lock}")

      unlock = current_definition.instance_variable_get(:@unlock)
      definition = Bundler::Definition.build(GEMFILE, lock, unlock)
      definition.resolve_remotely!
      definition.lock(lock)
    end

    def which_lock
      if Bundler.default_lockfile.to_s =~ /_next\.lock/
        GEMFILE_LOCK
      else
        GEMFILE_NEXT_LOCK
      end
    end
  end
end
