# encoding: utf-8
require_relative 'base'

module Metriknit
  module Runner

    # Run an external command, returning the result
    class ExternalCommandRunner < Base

      def run
        `bundle exec #{run_command}`
      end

      protected

      # Implement in subclasses
      def run_command; end

    end

  end
end
