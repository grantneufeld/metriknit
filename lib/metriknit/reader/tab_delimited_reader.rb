# encoding: utf-8
require_relative 'base'

module Metriknit
  module Reader

    # ABSTRACT CLASS
    # Read in a tab-delimited text data source
    class TabDelimitedReader < Base

      # Relies on `file` behaving like an (open) IO object - accepting `gets`.
      def parse
        warnings = []
        while line = file.gets
          warning = line_to_warning(line)
          warnings << warning if warning
        end
        warnings
      end

      protected

      def line_to_warning(line)
        fields = line_to_fields(line)
        if fields
          parse_fields_to_warning(fields)
        else
          nil
        end
      end

      def line_to_fields(line)
        line = line.strip
        unless line.blank?
          line.split("\t")
        end
      end

      # Requires `parse_fields_to_warning` to be defined in sub-class.

    end

  end
end
