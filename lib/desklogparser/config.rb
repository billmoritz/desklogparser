require 'desklogparser/version'
require 'optparse'
require 'ostruct'

module Desklogparser
  class Config
    def self.parse(args)
      options = OpenStruct.new
      options.file = 'sample.log'
      options.type = 'combined'

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: logparser [options]'

        opts.separator ''
        opts.separator 'Options:'

        opts.on('-f', '--file LOGFILE',
                'Specify the LOGFILE to parse') do |file|
          options.file = file
        end

        opts.on('--type [TYPE]', [:common, :combined],
                'Select the logfile format TYPE (common, combined)') do |type|
          options.transfer_type = type
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          puts VERSION
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
