# encoding: utf-8
require_relative 'metriknit'
require_relative 'progress'
require_relative 'progress_minimal'
require_relative 'progress_null'
require 'optparse'

module Metriknit

  # Command-line interface to run metriknit.
  class Cli

    # Takes an array of arguments; typically `ARGV` from a command-line call.
    def run(args)
      parse_arguments_to_options(args)

      if options[:help]
        puts parser
        exit
      end

      metriknit = Metriknit.new(
        output_hash.merge(
          format: options[:format],
          progress: progress,
          debug: options[:debug],
          git_only: options[:git_only],
          scans: options
        )
      )
      metriknit.merge
      metriknit.output

      `open #{options[:filepath]}` if options[:open]
      `mate #{options[:filepath]}` if options[:textmate]
    end

    private

    def parse_arguments_to_options(args)
      leftovers = parser.parse args
      options[:filepath] = leftovers[0]
      if options[:filepath].blank?
        options[:textmate] = false
      end
      if options[:quiet]
        options[:progress] = options[:debug] = false
      end
      options
    end

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner += ' output/file/path'

        opts.on '-h', '--help', '-?', 'Display this usage message' do
          options[:help] = true
        end

        opts.separator ""
        opts.separator "Processing options:"
        opts.on '-g', '--git-only', 'Show only files that have uncommitted changes in git' do
          options[:git_only] = true
        end
        opts.on '-p', '--progress', 'Show significant progress information messages' do
          options[:progress] = :progress
        end
        opts.on '-v', '--verbose', 'Show all progress information messages (implies -p)' do
          options[:progress] = :verbose
        end
        opts.on '-d', '--debug', 'Show debugging information messages' do
          options[:debug] = true
        end
        opts.on '-q', '--quiet', 'Hide all information messages (overrides -p, -v, -d)' do
          options[:quiet] = true
        end

        opts.separator ""
        opts.separator "Output options:"
        opts.on '-f FORMAT', '--format FORMAT', 'Output format (text or html; default: text)' do |format|
          options[:format] = format.to_sym
        end
        opts.on '-o', '--open', 'Open report using default app' do
          options[:open] = true
        end
        opts.on '-m', '--textmate', 'Open report in Textmate (if filepath given)' do
          options[:textmate] = true
        end

        opts.separator ""
        opts.separator "Scanning options:"
        opts.on "--[no-]brakeman", "Include Brakeman scan" do |do_scan|
          options[:brakeman] = do_scan
        end
        opts.on "--[no-]cane", "Include Cane scan" do |do_scan|
          options[:cane] = do_scan
        end
        opts.on "--[no-]churn", "Include Churn scan" do |do_scan|
          options[:churn] = do_scan
        end
        opts.on "--[no-]flog", "Include Flog scan" do |do_scan|
          options[:flog] = do_scan
        end
        opts.on "--[no-]notes", "Include Notes scan" do |do_scan|
          options[:notes] = do_scan
        end
        opts.on "--[no-]rbp", "Include Rails Best Practices scan" do |do_scan|
          options[:rbp] = do_scan
        end
        opts.on "--[no-]reek", "Include Reek scan" do |do_scan|
          options[:reek] = do_scan
        end
        opts.on "--[no-]roodi", "Include Roodi scan" do |do_scan|
          options[:roodi] = do_scan
        end
        opts.on "--[no-]tailor", "Include Tailor scan" do |do_scan|
          options[:tailor] = do_scan
        end
      end
    end

    def options
      @options ||= options_defaults
    end

    def options_defaults
      {
        git_only: false, format: :text, progress: false, debug: false, quiet: false,
        open: false, textmate: false, help: false,
        filepath: nil
      }
    end

    def output_hash
      if options[:filepath].blank?
        {output_io: $stdout}
      else
        progress.puts "Results will be saved in #{options[:filepath]}"
        {output_file: options[:filepath]}
      end
    end

    def progress
      unless @progress
        case options[:progress]
        when :progress
          @progress = ProgressMinimal.new(out: $stderr)
        when :verbose
          @progress = Progress.new(out: $stderr)
        else
          @progress = ProgressNull.new
        end
      end
      @progress
    end

  end

end
