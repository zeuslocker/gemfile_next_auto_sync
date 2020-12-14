# frozen_string_literal: true
require 'pry'

module GemfileNextAutoSync
  class Synchronizer < Bundler::Plugin::API
    GEMFILE = ::Bundler.default_gemfile
    GEMFILE_LOCK = Pathname("#{GEMFILE}.lock")
    GEMFILE_NEXT_LOCK = Pathname("#{GEMFILE}.next.lock")
    GEMFILE_NEXT =  Pathname("#{GEMFILE}.next")

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
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_NEXT_LOCK does not exist, skiped!") unless GEMFILE_NEXT_LOCK.exist?
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_LOCK does not exist, skiped!") unless GEMFILE_LOCK.exist?
        next if !GEMFILE_LOCK.exist? || !GEMFILE_NEXT_LOCK.exist?
        @previous_lock = Bundler.default_lockfile.read
      end

      self.class.hook('after-install-all') do
        current_definition = Bundler.definition
        next_definition = Bundler::Definition.build(GEMFILE_NEXT, GEMFILE_NEXT_LOCK, nil)

        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_NEXT_LOCK does not exist, skiped!") unless GEMFILE_NEXT_LOCK.exist?
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_LOCK does not exist, skiped!") unless GEMFILE_LOCK.exist?
        binding.pry
        next if !GEMFILE_LOCK.exist? || !GEMFILE_NEXT_LOCK.exist? ||
          (nothing_changed?(current_definition) && nothing_changed?(next_definition))

        update!(current_definition)
      end
    end

    def nothing_changed?(current_definition)
      current_definition.to_lock == @previous_lock
    end

    def update!(current_definition)
      ENV['BOOTBOOT_UPDATING_ALTERNATE_LOCKFILE'] = '1'
      lock = which_lock
      Bundler.ui.confirm("Updating the #{lock}")

      definition = Bundler::Definition.build(GEMFILE_NEXT, GEMFILE_NEXT, nil)
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
