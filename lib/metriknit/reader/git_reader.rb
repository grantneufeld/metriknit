# encoding: utf-8
require_relative 'base'

module Metriknit
  module Reader

    # Read in a Git plain text data source
    class GitReader < Base

      def parse
        files = []
        while line = file.gets
          match = line.match(/^.. (.+)$/)
          filepath = match[1] if match
          files << filepath if filepath
        end
        files
      end

    end

  end
end
