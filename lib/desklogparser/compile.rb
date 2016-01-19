module Desklogparser
  class Compile
    def initialize(d)
      @data = d
    end

    def requests
      requests = {}
      @data.keys.each do |day|
        requests[day] = @data[day].count
      end
      requests
    end

    def agents
      agents = {}
      @data.keys.each do |day|
        agents[day] = Hash.new(0)
        @data[day].each do |line|
          agents[day][line['user_agent']] += 1
        end
        agents[day] = agents[day].sort_by { |_k, v| v }.reverse
        agents[day] = agents[day][0..2]
      end
      agents
    end

    def httpmethods
      httpmethods = {}
      @data.keys.each do |day|
        httpmethods[day] = {}
        @data[day].each do |line|
          if httpmethods[day][line['user_agent']].nil?
            httpmethods[day][line['user_agent']] = Hash.new(0)
          end
          httpmethods[day][line['user_agent']][line['method']] += 1
        end
      end
      httpmethods
    end
  end
end
