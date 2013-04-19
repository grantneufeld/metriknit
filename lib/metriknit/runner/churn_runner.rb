# encoding: utf-8
require_relative 'external_command_runner'

module Metriknit
  module Runner

    # Run the Churn metrics as an external command, returning the result
    class ChurnRunner < ExternalCommandRunner

      protected

      # Get yaml data from Churn.
      def run_command
        'churn --yaml --start_date=2013-01-01 --ignore_files="Gemfile,Gemfile.lock,config/routes.rb,db/schema.rb,preflight,spec/factories.rb,README.rdoc"'
      end

    end

  end
end
