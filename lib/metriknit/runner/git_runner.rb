# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Git status as an external command, returning the result
    class GitRunner < ExternalCommandRunner

      protected

      # Get text data from Git.
      def run_command
        # this should probably be run without bundle exec, I guess
        'git status --porcelain'
      end

    end

  end
end
