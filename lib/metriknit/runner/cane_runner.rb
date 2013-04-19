# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Cane metrics as an external command, returning the result
    class CaneRunner < ExternalCommandRunner

      protected

      # Get json-formatted data from Cane.
      def run_command
        'cane --style-measure 110 --parallel --json'
      end

    end

  end
end
