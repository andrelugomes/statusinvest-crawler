#! /usr/bin/env ruby
require './stock.rb'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: stocks.rb --my|--radar|[TICKERS]"

  opts.on("--my", "Get tickers from my_stocks.txt") do |file|
    options[:file] = File.read("my_stocks.txt").split
  end

  opts.on("--radar", "Get tickers from radar_stocks.txt") do |file|
    options[:file] = File.read("radar_stocks.txt").split
  end

end.parse!

p "Options #{options}"
p "Arguments #{ARGV}"

stock = Stock.new

if ARGV[0]
    ARGV.each do|ticker|
        puts "Crawling from Argument: #{ticker}"
        stock.crawling(ticker)
    end
end

if options[:file]
    tickers = options[:file]

    tickers.each do |ticker| 
        puts "Crawling from tickers.txt: #{ticker}" 
        stock.crawling(ticker)
    end
end
