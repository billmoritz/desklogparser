require 'apache_log/parser'

module Desklogparser
  class ApacheParser
    def self.parse(opts)
      logfile = File.open(opts.file)
      parser = ApacheLog::Parser.new(opts.type)
      results = Hash.new([])
      while ! logfile.eof?
        logline = logfile.readline
        begin
          log = parser.parse(logline)
        rescue StandardError => error
          puts error
        end
        results[log[:datetime].to_date.day] += [{
          'method' => log[:request][:method],
          'user_agent' => log[:user_agent]
        }]
      end
      results
    end
  end
end
