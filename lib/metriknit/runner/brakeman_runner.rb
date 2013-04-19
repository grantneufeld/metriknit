# encoding: utf-8
require_relative 'external_command_runner'
#require_relative 'base'
#require_relative '../warning/line_warning'
#require 'brakeman'
#require 'brakeman/scanner'
#require 'set'

module Metriknit
  module Runner

    # Run the Brakeman metrics as an external command, returning the result
    class BrakemanRunner < ExternalCommandRunner # Base

      # FIXME: uncomment these lines when the direct running of the brakeman gem is working
      #def run
      #  tracker = run_checks
      #  tracker_to_warnings(tracker)
      #end

      protected

      # Get tab-delimited data from brakeman.
      def run_command
        'brakeman --format tabs --message-limit 1023 --routes --separate-models --confidence-level 1' +
          (progress? ? ' --no-quiet' : '--quiet' ) + (debug ? ' --debug' : '')
      end

      #private

      #def run_checks
      #  update_chunk "Setting options"
      #  scanner = Brakeman::Scanner.new options
      #  update_chunk "Processing application"
      #  tracker = scanner.process
      #  update_chunk "Runnning checks"
      #  tracker.run_checks
      #  tracker
      #end

      ## Commandline parameters:
      ## --quiet --format tabs --message-limit 1024 --routes --separate-models --confidence-level 1
      #def options
      #  Brakeman.get_defaults.merge(
      #    # defaults:
      #    #assume_all_routes: true, # Assume all controller methods are actions (default)
      #    #skip_checks: Set.new,
      #    #check_arguments: true, # ?
      #    #safe_methods: Set.new,
      #    #min_confidence: 2, # = 3 - confidence_level(1); Set minimal confidence level (1 - 3)
      #    #combine_locations: true,
      #    #collapse_mass_assignment: true,
      #    #highlight_user_input: true,
      #    #ignore_redirect_to_model: true, # ?
      #    #ignore_model_output: false,
      #    #message_limit: 100,
      #    #parallel_checks: true, # Run checks in parallel (sequentially if false)
      #    #relative_path: false, # ?
      #    #quiet: true,
      #    #report_progress: true,
      #    #html_style: "#{File.expand_path(File.dirname(__FILE__))}/brakeman/format/style.css"
      #    # command options
      #    #exit_on_warn: false, # Exit code is non-zero if warnings found
      #    #output_format: :to_tabs, # Specify output formats. Default is text
      #    # check options:
      #    collapse_mass_assignment: false, # Warn on each model without attr_accessible (--separate-models)
      #    #combine_locations: false, # Combine warning locations (Default) #•••
      #    escape_html: false, # Escape HTML by default
      #    #parallel_checks: false, # Run checks in parallel (sequentially if false)
      #    #rails3: false, # Force Rails 3 mode
      #    #run_checks: Set.new,
      #    skip_files: Set.new,
      #    #url_safe_methods: Set.new,
      #    # report options
      #    #message_limit: 1024, # Limit message length in HTML report
      #    #relative_paths: true, # Output relative file paths in reports
      #    report_routes: true, # Report controller information (--routes)
      #    # setup
      #    app_path: project_root, # Specify path to Rails application
      #    debug: debug, # Lots of output
      #    quiet: progress?, # Suppress informational messages
      #    report_progress: progress? # Show progress reports
      #  )
      #end

      #def tracker_to_warnings(tracker)
      #  warnings = []
      #  tracker.checks.warnings.each do |warn|
      #    warnings << check_warn_to_warning(warn)
      #  end
      #  tracker.checks.model_warnings.each do |warn|
      #    warnings << check_warn_to_warning(warn)
      #  end
      #  tracker.checks.controller_warnings.each do |warn|
      #    warnings << check_warn_to_warning(warn)
      #  end
      #  tracker.checks.template_warnings.each do |warn|
      #    warnings << check_warn_to_warning(warn)
      #  end
      #  warnings
      #end

      #def check_warn_to_warning(warn)
      #  user_input = warn.user_input
      #  message = warn.message.gsub(user_input, "\\^#{user_input}\\$") if user_input
      #  Warning::LineWarning.new({
      #    filepath: warn.file,
      #    class_name: warn.class,
      #    method_name: warn.method,
      #    line: warn.line,
      #    warning_type: warn.warning_type,
      #    category: warn.warning_set,
      #    message: message,
      #    confidence: warn.to_hash[:confidence],
      #    url: warn.link,
      #    source: 'brakeman'
      #  })
      #end

    end

  end
end
