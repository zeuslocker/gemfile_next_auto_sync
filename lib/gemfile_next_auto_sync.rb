# frozen_string_literal: true

require_relative 'gemfile_next_auto_sync/version'
require_relative "gemfile_next_auto_sync/bundler_patch"

module GemfileNextAutoSync
  autoload :Synchronizer, 'gemfile_next_auto_sync/synchronizer'
end

GemfileNextAutoSync::Synchronizer.new.setup
