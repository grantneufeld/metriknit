# encoding: utf-8
require_relative 'base'
require_relative '../warning/line_warning'

module Metriknit
  module Reader

    # Read in a Notes annotations hash
    class NotesReader < Base
      attr_reader :metrics

      def parse
        @warnings = []
        metrics.each do |filepath, annotations|
          annotations_to_warnings(filepath, annotations)
        end
        @warnings
      end

      protected

      def post_initialize(args={})
        @metrics = args[:metrics]
      end

      def annotations_to_warnings(filepath, annotations)
        annotations.each do |annotation|
          @warnings << annotation_to_warning(filepath, annotation)
        end
      end

      def annotation_to_warning(filepath, annotation)
        Warning::LineWarning.new(
          filepath: filepath,
          line: annotation.line,
          warning_type: annotation.tag,
          message: annotation.text,
          source: 'notes'
        )
      end

    end

  end
end
