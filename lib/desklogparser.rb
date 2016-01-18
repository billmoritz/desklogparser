
require 'apache_log/parser'

class Desklogparser
  def run
    conf = config
    parsed = parse(conf)
    output(parsed)
  end

  def config
    { 'file' => 'sample.log', 'type' => 'combined' }
  end

  def parse(opts)
    logfile = File.open(opts['file'])
    parser = ApacheLog::Parser.new(opts['type'])
    results = Hash.new([])
    while ! logfile.eof?
      logline = logfile.readline
      begin
        log = parser.parse(logline)
      rescue StandardError => e
        puts e
      end
      results[log[:datetime].to_date.day] += [{
        'method' => log[:request][:method],
        'user_agent' => log[:user_agent]
      }]
    end
    results
  end

  def compile_requests(data)
    requests = {}
    data.keys.each do |day|
      requests[day] = data[day].count
    end
    requests
  end

  def compile_agents(data)
    agents = {}
    data.keys.each do |day|
      agents[day] = Hash.new(0)
      data[day].each do |line|
        agents[day][line['user_agent']] += 1
      end
      agents[day] = agents[day].sort_by { |_k, v| v }.reverse
      agents[day] = agents[day][0..2]
    end
    agents
  end

  def compile_methods(data)
    methods = {}
    data.keys.each do |day|
      methods[day] = {}
      data[day].each do |line|
        if methods[day][line['user_agent']].nil?
          methods[day][line['user_agent']] = Hash.new(0)
        end
        methods[day][line['user_agent']][line['method']] += 1
      end
    end
    methods
  end

  def output(parsed)
    output_requests(compile_requests(parsed))
    output_agents(compile_agents(parsed))
    output_methods(compile_methods(parsed))
  end

  # What are the 3 most frequent User Agents by day?
  def output_agents(frequency_agents)
    puts "\n3 most frequent User Agents by day"
    frequency_agents.keys.each do |day|
      puts "DAY: #{day} "
      frequency_agents[day].each do |agent|
        puts "  COUNT: #{agent[0]} AGENT: #{agent[1]}"
      end
    end
  end

  # What are the number of requests served by day?
  def output_requests(num_requests)
    puts "\nNumber of requests served by day"
    num_requests.each do |day, requests|
      puts "DAY: #{day} REQUESTS: #{requests}"
    end
  end

  # What is the ratio of GET's to POST's by OS by day?
  def output_methods(ratio_methods)
    puts "\nRatio of GET's to POST's by OS by day"
    ratio_methods.keys.each do |day|
      puts "DAY: #{day} "
      ratio_methods[day].keys.each do |agent|
        gets = ratio_methods[day][agent]['GET'] ||= 0
        posts = ratio_methods[day][agent]['POST'] ||= 0
        puts "  AGENT: #{agent} RATIO: #{gets / posts.to_f}"
      end
    end
  end
end
