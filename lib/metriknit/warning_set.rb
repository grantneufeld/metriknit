# encoding: utf-8

module Metriknit

  # An organized collection of Warnings.
  class WarningSet
    attr_reader :project_root_path

    def initialize(params={})
      @set = {}
      @project_root_path = params[:project_root_path] || '.'
    end

    def add_warning(warning)
      filepath = warning.filepath
      @set[filepath] ||= {warnings: [], lines: {}, classes: {}}
      line_number = warning.line
      if line_number.blank?
        class_name = warning.class_name
        @set[filepath][:classes][class_name] ||= {warnings: [], methods: {}}
        method_name = warning.method_name
        if method_name.blank?
          @set[filepath][:classes][class_name][:warnings] << warning
        else
          @set[filepath][:classes][class_name][:methods][method_name] ||= []
          @set[filepath][:classes][class_name][:methods][method_name] << warning
        end
      else
        @set[filepath][:lines][line_number] ||= []
        @set[filepath][:lines][line_number] << warning
      end
    end

    def output_html(output, restrict_to_files=nil)
      @set.keys.sort.each do |filepath|
        if !(restrict_to_files) || restrict_to_files.include?(filepath)
          output_html_for_filepath(output: output, filepath: filepath)
        end
      end
      nil
    end

    def output_html_for_filepath(params)
      filepath = params[:filepath]
      output = params[:output]
      output.print '<div class="file">'
      output.puts "<h2 class=\"filepath\">#{filepath}</h2>"
      hash = @set[filepath]
      # line warnings
      output.puts '<table><tbody>'
      hash[:lines].keys.sort.each do |line_number|
        hash[:lines][line_number].each do |line_warning|
          output.puts "<tr class=\"warning\">" +
          "<td>#{textmate_link(filepath, line_number)}<span class=\"separator\">:</span></td> " +
          "#{line_warning.to_html}</tr>"
        end
      end
      output.puts '</tbody></table>'
      # class warnings
      hash[:classes].keys.sort.each do |class_name|
        output.puts "<h3 class=\"class\">#{class_name}</h3>"
        output.puts '<table><tbody>'
        hash[:classes][class_name][:warnings].each do |warning|
          output.puts "<tr class=\"warning\"><td></td>#{warning.to_html}</tr>"
        end
        # method warnings
        hash[:classes][class_name][:methods].keys.sort.each do |method_name|
          hash[:classes][class_name][:methods][method_name].each do |warning|
            output.puts "<tr class=\"warning\">" +
            "<td class=\"method\">#{class_name}#{method_name}<span class=\"separator\">:</span></td> " +
            "#{warning.to_html}</tr>"
          end
        end
        output.puts '</tbody></table>'
      end
      output.puts '</div>'
    end

    def textmate_link(filepath, line)
      url = "txmt://open/?url=file://#{File.expand_path(project_root_path)}/#{filepath}&amp;line=#{line}"
      "<a class=\"line\" href=\"#{url}\">#{line}</a>"
    end

    # output must be a writable IO
    # restrict_to_files must be nil or an Array of filepaths
    def output_text(output, restrict_to_files=nil)
      @set.keys.sort.each do |filepath|
        if !(restrict_to_files) || restrict_to_files.include?(filepath)
          output_text_for_filepath(output: output, filepath: filepath)
        end
      end
      nil
    end

    def output_text_for_filepath(params)
      filepath = params[:filepath]
      output = params[:output]
      output.puts '' # blank line
      output.puts filepath
      hash = @set[filepath]
      # class warnings
      hash[:classes].keys.sort.each do |class_name|
        hash[:classes][class_name][:warnings].each do |warning|
          output.puts(label_string(class_name, warning))
        end
        # method warnings
        hash[:classes][class_name][:methods].keys.sort.each do |method_name|
          hash[:classes][class_name][:methods][method_name].each do |warning|
            output.puts(label_string("#{class_name}#{method_name}", warning))
          end
        end
      end
      # line warnings
      hash[:lines].keys.sort.each do |line_number|
        hash[:lines][line_number].each do |line_warning|
          output.puts(label_string(line_number, line_warning))
        end
      end
    end

    def label_string(label, str)
      if label.blank?
        str
      else
        "#{label}: #{str}"
      end
    end

  end

end
