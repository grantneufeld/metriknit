# encoding: utf-8

module Metriknit

  class Progress

    def initialize(params={})
      @out = params[:out] || $stdout
    end

    # print the message as a whole line, ensuring it starts on a new line
    def puts(message)
      @out.puts ''
      @out.puts message
    end

    # ignore the message and just print a tick mark
    def print(message)
      @out.print '.'
    end

  end

end
