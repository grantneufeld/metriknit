# encoding: utf-8
require_relative 'merger'
require_relative 'progress_null'
require_relative 'runner/git_runner'
require_relative 'reader/git_reader'

module Metriknit

  class Metriknit
    attr_reader :warning_set
    attr_reader :scans
    attr_reader :git_only
    attr_reader :output_filepath
    attr_reader :output_io
    attr_reader :format
    attr_reader :progress
    attr_reader :debug

    def initialize(params={})
      @git_only = params[:git_only] || false
      @scans = params[:scans] || {}
      @format = params[:format] || :text
      @output_filepath = params[:output_file] || "metriknit.#{format}"
      @output_io = params[:output_io]
      @progress = params[:progress] || ProgressNull.new
      @debug = params[:debug] || false
    end

    def merge
      merger = Merger.new(progress: progress, debug: debug, scans: scans)
      merger.merge_all
      @warning_set = merger.warning_set
      nil
    end

    def output
      if output_io
        output_to_io(output_io)
      else
        ::File.open(output_filepath, 'w') do |file|
          output_to_io(file)
        end
      end
      nil
    end

    def output_to_io(io)
      restrict_to_files = git_only ? git_uncommitted_files : nil
      case format
      when :text
        warning_set.output_text(io, restrict_to_files)
      when :html
        output_html_to_io(io, restrict_to_files)
      end
    end

    def output_html_to_io(io, restrict_to_files)
      io.puts "<!DOCTYPE html>"
      io.puts "<html lang=\"en\"><head><meta charset=\"utf-8\"><title>Metriknit Report</title>"
      io.puts "<link rel=\"stylesheet\" href=\"#{css_path}\" type=\"text/css\" />"
      io.puts "</head><body><h1>Metriknit Report (#{Time.now.strftime('%Y-%m-%d, %-l:%M%P')})</h1>"
      warning_set.output_html(io, restrict_to_files)
      io.puts "</body></html>"
    end

    def css_path
      File.expand_path('../../assets/stylesheets/metriknit.css', File.dirname(__FILE__))
    end

    # returns an array of filepath strings for files that have uncommitted changes.
    def git_uncommitted_files
      git_status = Runner::GitRunner.new.run
      Reader::GitReader.new(string: git_status).parse
    end

  end

end
