# encoding: utf-8

module Metriknit
  module Warning

    # ABSTRACT CLASS
    # Use a subclass to hold a specific type of warning from a metrics report.
    class Base
      attr_accessor :filepath, :class_name, :method_name, :line, :column, :source,
        :warning_type, :category, :message, :confidence, :score, :url
      # might be a better name for "confidence". It’s currently take from brakeman.

      def initialize(args={})
        self.filepath = args[:filepath] || ''
        self.class_name = args[:class_name] || ''
        self.method_name = args[:method_name] || ''
        self.line = args[:line] || ''
        self.column = args[:column]
        self.warning_type = args[:warning_type]
        self.category = args[:category]
        self.message = args[:message]
        self.confidence = args[:confidence]
        self.score = args[:score]
        self.source = args[:source]
        self.url = args[:url]
      end

      def to_html
        meta_tags = html_meta_tags
        "<td class=\"warning_source\">#{source}<span class=\"separator\">:</span></td> " +
        "<td class=\"warning_message\">#{message}" +
        (meta_tags.blank? ? '' : "<br /><span class=\"meta\">#{meta_tags}</span>") +
        "</td>"
      end

      def html_meta_tags
        [
          html_meta_with_label('column', column),
          html_meta_with_label('type', warning_type),
          html_meta_with_label('category', category),
          html_meta_with_label('confidence', confidence),
          html_meta_with_label('score', score)
        ].delete_if(){ |item| item.nil? }.join('<span class="separator">,</span> ')
      end

      def html_meta_with_label(label, value)
        value.blank? ? nil : "<span class=\"item\"><span class=\"label\">#{label}</span><span class=\"separator\">:</span><span class=\"value\">#{value}</span></span>"
      end

      # does not include the filepath line number
      def to_s
        note_items = [warning_type, category, confidence, score, column]
        # ignoring url, for now
        note_items.delete_if { |item| item.blank? }
        notes = (note_items).join('; ')
        notes = " (#{notes})" unless notes.blank?
        "[#{source}] #{message}" + notes
      end

      def class_name=(value)
        # strip leading colons
        @class_name = value.sub(/\A:+/, '')
      end

      # Normalize filepaths relative to the project root.
      # E.g., '/usr/me/projects/my_app/app/models/model.rb' becomes 'app/models/model.rb'
      def filepath=(value)
        project_path = File.absolute_path('.')
        if value
          @filepath = value.gsub(/\A#{project_path}\/*/, '').gsub(/\A\.\//, '')
        else
          @filepath = ''
        end
      end

      def line=(value)
        @line = convert_to_integer(value)
      end

      def column=(value)
        @column = convert_to_integer(value)
      end

      protected

      def convert_to_integer(value)
        value.blank? ? nil : value.to_s.to_i
      end

    end

  end
end
