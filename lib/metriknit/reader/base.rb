# encoding: utf-8

module Metriknit
  module Reader

    # ABSTRACT CLASS
    # Use a subclass to perform a specific type of reading from a data source.
    class Base
      attr_reader :file

      # A file or filepath can be passed in to indicate the data source.
      def initialize(args={})
        @file = args[:file]
        filepath = args[:filepath]
        unless @file || !filepath
          @file = ::File.open(filepath)
        end
        string = args[:string]
        unless @file || !string
          @file = StringIO.new(string, 'r')
        end
        post_initialize(args)
      end

      # Implement in subclasses
      def parse; end

      protected

      # Implement in subclasses:
      def post_initialize(args={}); end

      def class_and_method_names(value)
        result = nil
        result = {class_name: value} if is_class_name?(value)
        result = split_class_and_method(value) unless result
        result = split_anonymous_method(value) unless result
        result || {}
      end

      def is_class_name?(value)
        value.match /\A[A-Z][A-Za-z]+\z/
      end

      def split_class_and_method(value)
        match = value.match /\A([A-Za-z0-9_:]+)([#\.][^ \t\r\n\.\,\"\']+)\z/
        {class_name: match[1], method_name: match[2]} if match
      end

      def split_anonymous_method(value)
        match = value.match /\A\(anon\)([#\.][^ \t\r\n\.\,\"\']+)\z/
        {class_name: '', method_name: match[1]} if match
      end

    end

  end
end
