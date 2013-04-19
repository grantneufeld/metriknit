# encoding: utf-8
require_relative 'base'
require 'tailor'
require 'tailor/configuration/file_set'
require 'tailor/critic'
require_relative '../warning/line_warning'

module Metriknit
  module Runner

    # Run the Tailor analysis, returning the warnings
    class TailorRunner < Base
      attr_reader :max_line_length, :max_code_lines_in_class, :max_code_lines_in_method

      def run
        critic = Tailor::Critic.new
        @warnings = []
        critic.critique(filesets) do |problems_for_file, filepath|
          update_chunk(filepath)
          file_problems_to_warnings(problems_for_file)
        end
        @warnings
      end

      protected

      def file_problems_to_warnings(problems_for_file)
        problems_for_file.each do |filepath, problems|
          problems_to_warnings(filepath: filepath, problems: problems)
        end
      end

      def problems_to_warnings(params)
        params[:problems].each do |problem|
          @warnings << problem_to_warning(filepath: params[:filepath], problem: problem)
          update_tick("- #{problem[:type]}")
        end
      end

      def problem_to_warning(params)
        problem = params[:problem]
        Warning::LineWarning.new({
          filepath: params[:filepath],
          line: problem[:line].to_s,
          column: problem[:column],
          message: problem[:message],
          warning_type: problem[:type],
          category: problem[:level],
          source: 'tailor'
        })
      end

      def post_initialize(params={})
        @max_line_length = params[:max_line_length] || 110
        @max_code_lines_in_class = params[:max_code_lines_in_class] || 200
        @max_code_lines_in_method = params[:max_code_lines_in_method] || 15
        Tailor::Logger.log = debug
      end

      def options
        @options ||= OpenStruct.new(
          config_file: '', output_file: '', show_config: false, output_color: false,
          formatters: ['text', 'yaml'],
          style: style
        )
      end

      # :level can be :error, :warn or :off
      def style
        {
          max_line_length: [max_line_length, level: :error],
          max_code_lines_in_class: [max_code_lines_in_class, level: :error],
          max_code_lines_in_method: [max_code_lines_in_method, level: :error],
          indentation_spaces: [2, level: :error],
          spaces_after_comma: [1, level: :error],
          spaces_before_comma: [0, level: :error],
          spaces_after_lbrace: [1, level: :error],
          spaces_before_lbrace: [1, level: :error],
          spaces_before_rbrace: [1, level: :error],
          spaces_in_empty_braces: [0, level: :error],
          spaces_after_lbracket: [0, level: :error],
          spaces_before_rbracket: [0, level: :error],
          spaces_after_lparen: [0, level: :error],
          spaces_before_rparen: [0, level: :error],
          # “allow_” is a bit confusing because on the command line the option flags are for disallowing
          allow_hard_tabs: [false, level: :error],
          allow_trailing_line_spaces: [false, level: :error],
          allow_camel_case_methods: [false, level: :error],
          allow_screaming_snake_case_classes: [false, level: :error],
          trailing_newlines: [1, level: :error]
        }
      end

      def filesets
        result = {}
        dirs.each do |dir|
          files = Dir.glob "#{dir}/**/*.rb"
          files.each do |file|
            result[file] = Tailor::Configuration::FileSet.new(file, style)
          end
        end
        result
      end

    end

  end
end
