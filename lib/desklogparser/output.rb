
module Desklogparser
  class Output
    def self.output(parsed)
      compile = Compile.new(parsed)
      requests(compile.requests)
      agents(compile.agents)
      httpmethods(compile.httpmethods)
    end

    # What are the 3 most frequent User Agents by day?
    def self.agents(frequency_agents)
      puts "\n3 most frequent User Agents by day"
      frequency_agents.keys.each do |day|
        puts "DAY: #{day} "
        frequency_agents[day].each do |agent|
          puts "  AGENT: #{agent[0]} COUNT: #{agent[1]}"
        end
      end
    end

    # What are the number of requests served by day?
    def self.requests(num_requests)
      puts "\nNumber of requests served by day"
      num_requests.each do |day, requests|
        puts "DAY: #{day} REQUESTS: #{requests}"
      end
    end

    # What is the ratio of GET's to POST's by OS by day?
    def self.httpmethods(ratio_httpmethods)
      puts "\nRatio of GET's to POST's by OS by day"
      ratio_httpmethods.keys.each do |day|
        puts "DAY: #{day} "
        ratio_httpmethods[day].keys.each do |agent|
          gets = ratio_httpmethods[day][agent]['GET'] ||= 0
          posts = ratio_httpmethods[day][agent]['POST'] ||= 0
          puts "  AGENT: #{agent} RATIO: #{gets / posts.to_f}"
        end
      end
    end
  end
end
