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

#movimentacao-2022-04-26-21-02-16.csv
#Entrada/Saída,Data,Movimentação,Produto,Instituição,Quantidade,Preço unitário,Valor da Operação
#Credito,30/12/2021,Dividendo,"B3SA3        - B3 S.A. – BRASIL, BOLSA, BALCÃO",XP INVESTIMENTOS CCTVM S/A,100," R$0,15 "," R$14,94 "
#Credito,30/12/2021,Juros Sobre Capital Próprio,BBAS3        - BANCO DO BRASIL S/A,XP INVESTIMENTOS CCTVM S/A,41," R$0,17 "," R$6,10 "

proventos = []

CSV.foreach('movimentacao-2022-04-26-21-02-16.csv', headers: true).with_index do |row, i|
    ticker = row[3].split(" ").first
    value = row[7].gsub("R$", "").gsub(",", ".").strip.to_f
    #initialize(name, event, quantity, value, net_value, ir, date)
    proventos << Ticker.new(ticker, row[2], row[5], value, value, row[7],row[1])
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
        when "RENDIMENTO"
            #fii = fii_crawler.crawling(events.first.name)
            #total_value_d = events.map { |e| e.value.to_f}.sum.round(2)
            #p "Rendimentos de #{events.first.name} CNPJ #{fii.cnpj} R$ #{total_value_d}"
        when "TOTAL"
        else
            p "unknown -> #{events.first.event}"
        end
    end
    
end