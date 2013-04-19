# encoding: utf-8
require_relative '../progress_null'

module Metriknit
  module Runner

    # ABSTRACT CLASS
    # Use a subclass to run a specific metric.
    class Base
      attr_reader :progress # Object that can receive the `puts` and `print` methods with a string argument
      attr_reader :debug # tell gems to show debug messages, when available
      attr_reader :dirs # array of directories to process
      attr_reader :files # array of files to process - should override dirs when supported by called gem
      attr_reader :project_root_path # path to the root directory we are analyzing
      attr_reader :debug # set to true if you want debugging messages from the metric processors

      def initialize(params={})
        @progress = params[:progress] || ProgressNull.new
        @debug = params[:debug] || false
        @dirs = params[:dirs] || %w(app config lib script spec test)
        @files = params[:files]
        @project_root_path = params[:project_root_path] || '.'
        post_initialize(params)
      end

      # Implement in subclasses
      def run; end

      protected

      # Implement in subclasses
      def post_initialize(params={}); end

      def project_root
        File.expand_path(project_root_path)
      end

      # message about the start of a chunk of the processing
      def update_chunk(message)
        progress.puts message if progress
      end

      # message about a step within a chunk of the processing
      def update_tick(message)
        progress.print message if progress
      end

      def progress?
        !(progress.nil?)
      end

    end

  end
end
