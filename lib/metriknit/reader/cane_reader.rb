# encoding: utf-8
require_relative 'json_reader'
require_relative '../warning/line_warning'
require_relative '../warning/method_warning'

module Metriknit
  module Reader

    # Read in a Cane json-format data source
    class CaneReader < JsonReader

      protected

      def parse_hash(hash)
        values = {
          filepath: hash['file'],
          line: hash['line'],
          warning_type: type_from_hash(hash),
          message: message_from_hash(hash),
          score: hash['value'],
          source: 'cane'
        }.merge(class_and_method_names(hash['label']))
        if values[:line]
          Warning::LineWarning.new(values)
        else
          Warning::MethodWarning.new(values)
        end
      end

      # map a description to a warning type
      def type_from_hash(hash)
        description = hash['description']
        CANE_TYPE_MAP[description] || description
      end

      CANE_TYPE_MAP = {
        'Files contained invalid syntax' => 'InvalidSyntax', # AbcCheck::InvalidAst
        'Methods exceeded maximum allowed ABC complexity' => 'TooComplex', # AbcCheck::RubyAst
        'Class definitions require explanatory comments on preceding line' => 'ClassCommentMissing', # DocCheck
        'Missing documentation' => 'DocumentationMissing', # DocCheck
        'Lines violated style requirements' => 'StyleViolation', # StyleCheck
        'Quality threshold could not be read' => 'ThresholdUnreadable', # ThresholdCheck
        'Quality threshold crossed' => 'ThresholdCrossed' # ThresholdCheck
      }

      def message_from_hash(hash)
        case type_from_hash(hash)
        when 'TooComplex'
          "ABC complexity: #{hash['value']}"
        when 'DocumentationMissing'
            hash['label']
        when 'StyleViolation'
          hash['label']
        when 'ThresholdUnreadable'
          "#{hash['description']}: #{hash['label']}"
        when 'ThresholdCrossed'
          "#{hash['description']}: #{hash['label']}"
        else
          hash['description']
        end
      end

    end

  end
end
