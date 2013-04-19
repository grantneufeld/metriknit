# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Flog metrics as an external command, returning the result
    class FlogRunner < ExternalCommandRunner

      protected

      # Get text data from Flog.
      def run_command
        'flog --continue --methods-only --19 app lib'
      end

    end

  end
end
