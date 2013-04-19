# encoding: utf-8
require_relative 'yaml_reader'
require_relative '../warning/line_warning'
require 'ostruct'

module Reek
  class SmellWarning
    attr_accessor :smell, :status, :location
    def initialize
      @smell = OpenStruct.new({class: nil, subclass: nil, message: nil, call: nil, expression: nil, parameter: nil, receiver: nil, variable: nil, module_name: nil, parameter_name: nil, variable_name: nil, occurrences: nil, statement_count: nil, references: nil, depth: nil})
      @status = OpenStruct.new({is_active: nil})
      @location = OpenStruct.new({context: nil, lines: [], source: nil})
    end
  end
end

module Metriknit
  module Reader

    # Read in a Reek yaml-format data source
    class ReekReader < YamlReader

      protected

      def parse_yaml_to_warnings(yaml_doc)
        warnings = []
        yaml_doc.each do |smell|
          warning = parse_smell(smell)
          warnings << warning if warning
        end
        warnings
      end

      private

      def parse_smell(smell)
        line = smell.location['lines']
        # TODO: make note of the additional lines listed
        line = line[0] if line.is_a? Array
        score = smell.smell['occurrences'] || smell.smell['statement_count']
        score ||= smell.smell['references'] || smell.smell['depth']
        values = class_and_method_names(smell.location['context'])
        values.merge!({
          filepath: smell.location['source'],
          line: line,
          warning_type: smell.smell['class'],
          category: smell.smell['subclass'],
          message: smell.smell['message'],
          # ignoring these values as they seem to mostly be found within the message:
          # call, parameter, receiver, expression, variable, module_name, parameter_name, variable_name
          score: score,
          source: 'reek'
        })
        Warning::LineWarning.new(values)
      end

    end

  end
end
