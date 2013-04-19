# encoding: utf-8
require_relative 'yaml_reader'
require_relative '../warning/line_warning'
require_relative '../warning/method_warning'

module Metriknit
  module Reader

    # Read in a Churn yaml-format data source
    class ChurnReader < YamlReader

      protected

      def parse_yaml_to_warnings(yaml_doc)
        if yaml_doc.is_a? Hash
          churn = yaml_doc[:churn]
        else
          churn = nil
        end
        if churn
          parse_churn_hash(churn)
        else
          nil
        end
      end

      private

      def parse_churn_hash(churn)
        @warnings = []
        churn[:changes].each do |hash|
          add_warning parse_churn_change(hash).merge(common_fields(hash))
        end
        churn[:class_churn].each do |hash|
          add_warning parse_churn_class_churn(hash).merge(common_fields(hash))
        end
        churn[:method_churn].each do |hash|
          add_warning parse_churn_method_churn(hash).merge(common_fields(hash))
        end
        # ignore changed_files, changed_classes, changed_methods
        @warnings
      end

      def add_warning(values)
        warning = Warning::MethodWarning.new(values)
        @warnings << warning if warning
      end

      def common_fields(hash)
        score = hash['times_changed'] || hash[:times_changed]
        {message: "Changed #{score} times", score: score, warning_type: 'Change', source: 'churn'}
      end
      def parse_churn_change(hash)
        {filepath: hash[:file_path]}
      end
      def parse_churn_class_churn(hash)
        {filepath: hash['klass']['file'], class_name: hash['klass']['klass']}
      end
      def parse_churn_method_churn(hash)
        method_name = split_class_and_method(hash['method']['method'])[:method_name]
        {filepath: hash['method']['file'], class_name: hash['method']['klass'], method_name: method_name}
      end

    end

  end
end
