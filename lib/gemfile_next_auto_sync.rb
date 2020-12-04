# frozen_string_literal: true

require_relative 'gemfile_next_auto_sync/version'

module GemfileNextAutoSync
  GEMFILE = ::Bundler.default_gemfile
  GEMFILE_LOCK = Pathname("#{GEMFILE}.lock")
  GEMFILE_NEXT_LOCK = Pathname("#{GEMFILE}.next.lock")
  Gemfile.next.lock
  autoload :Synchronizer, 'gemfile_next_auto_sync/synchronizer'
end

GemfileNextAutoSync::Synchronizer.new.setup
