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
        next if GEMFILE.to_s.end_with?('next')
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_NEXT_LOCK does not exist, skiped!") unless GEMFILE_NEXT_LOCK.exist?
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_LOCK does not exist, skiped!") unless GEMFILE_LOCK.exist?
        next if !GEMFILE_LOCK.exist? || !GEMFILE_NEXT_LOCK.exist?
        @previous_lock = Bundler.default_lockfile.read
      end

      self.class.hook('after-install-all') do
        next if GEMFILE.to_s.end_with?('next')

        current_definition = Bundler.definition
        next_definition = Bundler::Definition.build(GEMFILE_NEXT, GEMFILE_NEXT_LOCK, nil)

        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_NEXT_LOCK does not exist, skiped!") unless GEMFILE_NEXT_LOCK.exist?
        Bundler.ui.warn("\n GemfileNextAutoSync: GEMFILE_LOCK does not exist, skiped!") unless GEMFILE_LOCK.exist?

        next if !GEMFILE_LOCK.exist? || !GEMFILE_NEXT_LOCK.exist? ||
          (nothing_changed?(current_definition) && nothing_changed?(next_definition))

        update!(current_definition)
      end
    end

    def nothing_changed?(current_definition)
      current_definition.to_lock == @previous_lock
    end

    def update!(current_definition)
      Bundler.ui.confirm("Updating the #{GEMFILE_NEXT_LOCK}")

      unlock = current_definition.instance_variable_get(:@unlock)
      definition = Bundler::Definition.build(GEMFILE_NEXT, GEMFILE_NEXT_LOCK, unlock)
      definition.resolve_remotely!
      definition.lock(GEMFILE_NEXT_LOCK)
    end
  end
end
