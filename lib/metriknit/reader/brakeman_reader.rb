# encoding: utf-8
require_relative 'tab_delimited_reader'
require_relative '../warning/line_warning'

module Metriknit
  module Reader

    # Read in a brakeman tab-delimited text data source
    class BrakemanReader < TabDelimitedReader

      protected

      def parse_fields_to_warning(fields)
        Warning::LineWarning.new(
          filepath: fields[0], line: fields[1].to_i, warning_type: fields[2], category: fields[3],
          message: fields[4], confidence: fields[5], source: 'brakeman'
        )
      end

    end

  end
end
