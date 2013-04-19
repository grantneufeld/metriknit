# encoding: utf-8
require_relative 'yaml_reader'
require_relative '../warning/line_warning'

module RailsBestPractices
  module Core
    class Error
      attr_accessor :filename, :line_number, :message, :type, :url,
        :git_commit, :git_username, :hg_commit, :hg_username
      def type
        @type.gsub(/^.*:/, '').gsub(/Review$/, '')
      end
    end
  end
end

module Metriknit
  module Reader

    # Read in a RailsBestPractices yaml-format data source
    class RailsBestPracticesReader < Base
      attr_reader :errors

      def parse
        warnings = []
        errors.each do |error|
          warnings << error_to_warning(error)
        end
        warnings
      end

      protected

      def post_initialize(args={})
        @errors = args[:metrics]
      end

      private

      def error_to_warning(error)
        values = {
          filepath: error.short_filename, # error.filename just within the target root directory
          line: error.line_number,
          message: error.message,
          warning_type: error.type,
          # ignoring error.url, error.git_commit, error.git_username - for now
          source: 'rails_best_practices'
        }
        Warning::LineWarning.new(values)
      end

    end

  end
end
