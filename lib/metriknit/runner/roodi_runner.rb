# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Roodi metrics as an external command, returning the result
    class RoodiRunner < ExternalCommandRunner

      protected

      # Get text data from Roodi.
      def run_command
        'roodi "app/**/*.rb" "lib/**/*.rb"'
      end

    end

  end
end
