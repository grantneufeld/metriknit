# encoding: utf-8
require_relative 'base'
require 'rails/source_annotation_extractor'

module Metriknit
  module Runner

    # Run the notes extractor, returning the result
    class NotesRunner < Base
      attr_reader :tags # array of tags to search for

      def run
        extractor = ::SourceAnnotationExtractor.new(tags.join('|'))
        extractor.find(dirs)
      end

      protected

      def post_initialize(params={})
        @tags = params[:tags] || %w(OPTIMIZE FIXME TODO)
      end

    end

  end
end
