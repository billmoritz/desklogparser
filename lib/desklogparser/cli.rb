module Desklogparser
  class CLI
    def self.run
      config = Config.parse(ARGV)
      parsed = ApacheParser.parse(config)
      Output.output(parsed)
    end
  end
end
