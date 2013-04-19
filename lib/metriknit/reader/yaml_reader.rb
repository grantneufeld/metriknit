# encoding: utf-8
require_relative 'base'
require 'yaml'

module Metriknit
  module Reader

    # Read in a Yaml format data source
    class YamlReader < Base

      def parse
        result = []
        YAML.load_documents(file) do |yaml_doc|
          warnings = parse_yaml_to_warnings(yaml_doc)
          result += warnings if warnings
        end
        result
      end

      # Implement in subclasses
      def parse_yaml_to_warning(yaml); end

    end

  end
end
