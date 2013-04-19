# encoding: utf-8
require_relative 'base'
require_relative '../warning/line_warning'

module Metriknit
  module Reader

    # Read in a Roodi plain text data source
    class RoodiReader < Base

      def parse
        warnings = []
        while line = file.gets
          warning = add_line_to_warning(line)
          warnings << warning if warning
        end
        warnings
      end

      protected

      def add_line_to_warning(line)
        fields = line.match /^(?<filepath>.+):(?<line>[0-9]+) - (?<message>.+)$/
        if fields
          parse_fields_to_warning(fields)
        else
          nil
        end
      end

      def parse_fields_to_warning(fields)
        Warning::LineWarning.new(
          filepath: fields[:filepath],
          line: fields[:line].to_i,
          message: fields[:message].gsub(/  +/, ' '),
          source: 'roodi'
        )
      end

    end

  end
end
