# encoding: utf-8
require_relative 'warning_set'
require_relative 'progress'
require_relative 'progress_null'
require_relative 'runner/brakeman_runner'
require_relative 'reader/brakeman_reader'
require_relative 'runner/cane_runner'
require_relative 'reader/cane_reader'
require_relative 'runner/churn_runner'
require_relative 'reader/churn_reader'
require_relative 'runner/flog_runner'
require_relative 'reader/flog_reader'
require_relative 'runner/notes_runner'
require_relative 'reader/notes_reader'
require_relative 'runner/rbp_runner'
require_relative 'reader/rails_best_practices_reader'
require_relative 'runner/reek_runner'
require_relative 'reader/reek_reader'
require_relative 'runner/roodi_runner'
require_relative 'reader/roodi_reader'
require_relative 'runner/tailor_runner'

module Metriknit

  class Merger
    attr_reader :warning_set
    attr_reader :scans
    attr_reader :debug

    def initialize(params={})
      @warning_set = params[:warning_set] || WarningSet.new
      @scans = scan_defaults.merge(params[:scans])
      @progress = params[:progress] || ProgressNull.new
      @debug = params[:debug] || false
    end

    def scan_defaults
      {
        brakeman: true, cane: true, churn: true, flog: true, notes: true,
        rbp: true, reek: true, roodi: true, tailor: true
      }
    end

    def merge_all
      merge_brakeman
      merge_cane
      merge_churn
      #merge_flay
      merge_flog
      merge_notes
      merge_rbp
      merge_reek
      merge_roodi
      merge_tailor
    end

    def merge_brakeman
      if scans[:brakeman]
        update_chunk('Generating Brakeman results')
        metrics = Runner::BrakemanRunner.new(progress: progress, debug: debug).run
        update_tick
        warnings = Reader::BrakemanReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_cane
      if scans[:cane]
        update_chunk('Generating Cane results')
        metrics = Runner::CaneRunner.new.run
        update_tick
        warnings = Reader::CaneReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_churn
      if scans[:churn]
        update_chunk('Generating Churn results')
        metrics = Runner::ChurnRunner.new.run
        update_tick
        warnings = Reader::ChurnReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_flog
      if scans[:flog]
        update_chunk('Generating Flog results')
        metrics = Runner::FlogRunner.new.run
        update_tick
        warnings = Reader::FlogReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_notes
      if scans[:notes]
        update_chunk('Generating Notes results')
        metrics = Runner::NotesRunner.new.run
        update_tick
        warnings = Reader::NotesReader.new(metrics: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_rbp
      if scans[:rbp]
        update_chunk('Generating Rails Best Practices results')
        metrics = Runner::RbpRunner.new.run
        update_tick
        warnings = Reader::RailsBestPracticesReader.new(metrics: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_reek
      if scans[:reek]
        update_chunk('Generating Reek results')
        metrics = Runner::ReekRunner.new.run
        update_tick
        warnings = Reader::ReekReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_roodi
      if scans[:roodi]
        update_chunk('Generating Roodi results')
        metrics = Runner::RoodiRunner.new.run
        update_tick
        warnings = Reader::RoodiReader.new(string: metrics).parse
        update_tick
        add_warnings_to_set(warnings)
        update_done
      end
    end

    def merge_tailor
      if scans[:tailor]
        update_chunk('Generating Tailor results')
        warnings = Runner::TailorRunner.new(progress: progress, debug: debug).run
        add_warnings_to_set(warnings)
        update_done
      end
    end

    protected

    # a progress object to pass to a runner
    attr_reader :progress

    def update_chunk(message)
      progress.puts message
    end

    def update_tick
      progress.print '.'
    end

    def update_done
      #progress.puts ''
    end

    def add_warnings_to_set(warnings)
      warnings.each do |warning|
        @warning_set.add_warning(warning)
      end
    end

  end

end
