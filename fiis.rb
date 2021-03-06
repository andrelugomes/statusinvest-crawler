#! /usr/bin/env ruby

require 'spreadsheet'
require 'optparse'
require './crawler.rb'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: fiis.rb --my|--radar|--xls|[TICKERS]"

  opts.on("--my", "Get tickers from my_fiis.txt") do |file|
    options[:file] = File.read("my_fiis.txt").split
  end

  opts.on("--radar", "Get tickers from radar_fiis.txt and my_fiis.txt") do |file|
    options[:file] = File.read("radar_fiis.txt").split
  end

  opts.on("--all", "Get tickers from my_fiis.txt and radar_fiis.txt") do |file|
    my = File.read("my_fiis.txt").split
    radar = File.read("radar_fiis.txt").split
    options[:file] = my + radar
  end

  opts.on("--xls", "Export to XLS") do |file|
    options[:export] = true
  end

end.parse!

p "Options #{options}"
p "Arguments #{ARGV}"

fii_crawler = Crawler::Fiis.new

if ARGV[0]
    ARGV.each do|ticker|
        crawling(ticker)
    end
end

if options[:file]
    options[:file].each_with_index do |ticker, index| 
      fii = fii_crawler.crawling(ticker)
      puts fii.print
      puts fii.print_max_price
      puts fii.print_earning_p
      puts fii.print_earning_vp
      puts fii.url
      puts "\n"
    end
end

if options[:export]
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    sheet1.name = 'Meus FIIs'
    sheet1.row(0).push 'Ticker', 'Nome', 'Valor', 'VP por COTA', 'PVP', '% DY', 'Valor DY 12 meses'

    sheet2 = book.create_worksheet
    sheet2.name = 'FIIs no Radar'
    sheet2.row(0).push 'Ticker', 'Nome', 'Valor', 'VP por COTA', 'PVP', '% DY', 'Valor DY 12 meses'
    

    File.read("my_fiis.txt").split.each_with_index do |ticker, index| 
        row = sheet1.row(index+1) #line number
        fii = fii_crawler.crawling(ticker)
        row.push fii.ticker, fii.name, fii.value, fii.vp, fii.pvp, fii.dy, fii.dy_value
    end

    File.read("radar_fiis.txt").split.each_with_index do |ticker, index| 
        row = sheet2.row(index+1) #line number
        fii = fii_crawler.crawling(ticker)
        row.push fii.ticker, fii.name, fii.value, fii.vp, fii.pvp, fii.dy, fii.dy_value
    end

    book.write 'excel-fiis.xls'
end