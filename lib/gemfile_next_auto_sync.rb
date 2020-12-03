# frozen_string_literal: true

require 'gemfile_next_auto_sunc/version'

module GemfileNextAutoSync
  GEMFILE = Bundler.default_gemfile
  GEMFILE_LOCK = Pathname("#{GEMFILE}.lock")
  GEMFILE_NEXT_LOCK = Pathname("#{GEMFILE}_next.lock")

  autoload :Synchronizer, 'gemfile_next_auto_sunc/synchronizer'
end

GemfileNextAutoSync::Synchronizer.new.setup
