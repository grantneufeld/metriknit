# encoding: utf-8
require_relative 'base'
require 'json'

module Metriknit
  module Reader

    # ABSTRACT CLASS
    # Read in a json data source
    class JsonReader < Base

      # Relies on `file` behaving like an (open) IO object - accepting `read`.
      def parse
        warnings = []
        raw_json = file.read
        parsed_json = JSON.parse(raw_json, create_additions: false)
        parsed_json.each do |hash|
          warning = parse_hash(hash)
          warnings << warning if warning
        end
        warnings
      end

      protected

      # Requires `parse_hash(hash)` to be defined in sub-class. It must return a Warning or nil.

    end

  end
end
