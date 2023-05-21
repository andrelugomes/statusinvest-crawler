#! /usr/bin/env ruby

require 'csv'
require './crawler.rb'

class Ticker

    def initialize(name, event, quantity, value, net_value, ir, date)
        @name = name
        @event = event
        @quantity = quantity
        @value = value
        @net_value = net_value
        @ir = ir
        @date = date
    end

    def name
        @name
    end

    def quantity
        @quantity
    end

    def value
        @value
    end

    def event
        @event
    end

    def ir
        @ir
    end
    
    def net_value
        @net_value
    end

end

#proventos-recebidos-2022-01-01-a-2022-12-31.xlsx - Proventos Recebidos.csv
#Reembolso é quando a ação esta alugada e recebeu dividendo ou JCP

proventos = []

CSV.foreach('temp/proventos-recebidos-2022-01-01-a-2022-12-31.xlsx - Proventos Recebidos.csv', headers: true).with_index do |row, i|
    ticker = row[0].split(" ").first
    value = row[6].gsub("R$", "").gsub(",", ".").strip.to_f
    #initialize(name, event, quantity, value, net_value, ir, date)
    #p "#{ticker} #{value} #{row[1]} #{row[2]} #{row[4]} "
    proventos << Ticker.new(ticker, row[2], row[4], value, value, nil,row[1])
end


stock_crawler = Crawler::Stocks.new
fii_crawler = Crawler::Fiis.new

proventos.group_by { |t| t.name }.values.each do | group | 
    p "####################################################################################################################"
    events = group.group_by { |t| t.event }
    events.each do | key, events |
        case key
        when "Dividendo"
            stock = stock_crawler.crawling(events.first.name)
            p "Rendimentos isentos e não tibutáveis"
            p "Cod. 9 - Lucros e Dividendos recebidos"
            total_value_d = events.map { |e| e.value.to_f}.sum.round(2)
            p "Dividendos de #{events.first.name} CNPJ #{stock.cnpj} R$ #{total_value_d}"
        when "Juros Sobre Capital Próprio" 
            stock = stock_crawler.crawling(events.first.name)
            p "Rendimentos Sujeitos a Tributação Exclusiva"
            p "Cod. 10 - Juros sob Capital próprio"
            total_net_value_d = events.map { |e| e.net_value.to_f}.sum.round(2)
            #total_value_d = events.map { |e| e.value.to_f}.sum.round(2)
            #total_ir = events.map { |e| e.ir.to_f}.sum.round(2)
            p "JCP de #{events.first.name} CNPJ #{stock.cnpj} Líquido R$ #{total_net_value_d}"
        when "Rendimento"
            p "Rendimentos isentos e não tibutáveis"
            p "Cod. 99 - Outros"
            fii = fii_crawler.crawling(events.first.name)
            total_value_d = events.map { |e| e.value.to_f}.sum.round(2)
            p "Rendimentos de #{events.first.name} CNPJ #{fii.cnpj} R$ #{total_value_d}"
        when "TOTAL"
        else
            #p "unknown -> #{events.first.event}"
        end
    end
    
end