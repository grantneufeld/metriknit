# encoding: utf-8
require_relative 'base'
require_relative '../warning/line_warning'

module Metriknit
  module Reader

    # Read in a Flog plain text data source
    class FlogReader < Base

      def parse
        warnings = []
        # skip the first 3 lines - summary score
        3.times do
          file.gets
        end
        while line = file.gets
          warning = line_to_warning(line)
          warnings << warning if warning
        end
        warnings
      end

      protected

      def post_initialize(args={})
        @flog_limit = 20.0
        @flog_limit = args[:flog_limit].to_f unless args[:flog_limit].blank?
      end

      def line_to_warning(line)
        fields = line.match /^ *(?<score>[0-9]+\.[0-9]+): (?<class_name>[^ \r\n]+)(?<method_name>[\#\.][^ \r\n]+) +(?<filepath>.+):(?<line>[0-9]+)$/
        if fields && score_big_enough?(fields[:score])
          parse_fields_to_warning(fields)
        else
          nil
        end
      end

      def score_big_enough?(score)
        score.to_f >= @flog_limit
      end

      def parse_fields_to_warning(fields)
        Warning::LineWarning.new(
          filepath: fields[:filepath], line: fields[:line].to_i,
          class_name: fields[:class_name], method_name: fields[:method_name],
          warning_type: 'Complexity',
          message: "#{fields[:class_name]}#{fields[:method_name]} complexity #{fields[:score]}",
          score: fields[:score],
          source: 'flog'
        )
      end

    end

  end
end
