# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Reek metrics as an external command, returning the result
    class ReekRunner < ExternalCommandRunner

      protected

      # Get yaml data from Reek.
      def run_command
        'reek --yaml --quiet --config config/reek.yml app/controllers app/helpers app/models app/presenters app/processors app/validators app/wayground lib spec'
      end

    end

  end
end
