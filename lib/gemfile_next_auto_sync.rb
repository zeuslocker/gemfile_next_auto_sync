# frozen_string_literal: true

require_relative 'gemfile_next_auto_sync/version'

module GemfileNextAutoSync
  autoload :Synchronizer, 'gemfile_next_auto_sync/synchronizer'
end

GemfileNextAutoSync::Synchronizer.new.setup
