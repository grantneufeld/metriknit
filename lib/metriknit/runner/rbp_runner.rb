# encoding: utf-8
require_relative 'base'
require 'rails_best_practices'

module Metriknit
  module Runner

    # Run the Rails Best Practices analyzer, returning the array of errors
    class RbpRunner < Base

      def run
        analyzer = RailsBestPractices::Analyzer.new(project_root_path, rbp_options)
        analyzer.analyze
        analyzer.errors
      end

      def rbp_options
        { 'debug' => false, 'silent' => true, 'with-git' => true, 'with-hg' => false }
        # 'only' => [] # array of files
      end

    end

  end
end
