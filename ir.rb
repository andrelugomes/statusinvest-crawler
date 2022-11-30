#! /usr/bin/env ruby

require 'csv'
require './crawler.rb'

class Ticker

    def initialize(name, value, quantity, op, type)
        @name = name
        @quantity = quantity
        @value = value
        @op = op
        @type = type
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

    def op
        @op
    end

    def type
        @type
    end

end

#operacoes.csv
#0,1,2,3,4,5,6,7,8
#Papel,Ticker,Preço,Quantidade,Operação,Data,Nota de Negociação,Tipo
#B3,B3SA3,11.41,100,compra,"December 23, 2021","",stock
#IRIDIUM,IRDM11,101.1,10,compra,"December 15, 2021","",fii

operations = []

CSV.foreach('temp/operacoes.csv', headers: true).with_index do |row, i|
    operations << Ticker.new(row[1], row[2], row[3], row[4], row[7])
end

p ">>> IR Bens e Direitos <<<"

p "Grupo 3 - participações Societárias"

p "Código 1 - Ações"

stock_crawler = Crawler::Stocks.new
stocks = operations.select { |t|  t.op == "compra"} .select { |t|  t.type == "stock"} .group_by{ |t| t.name }.values

stocks.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    total = group.map {|g| g.quantity.to_i * g.value.to_f}.sum
    average_price = total / quantity

    stock = stock_crawler.crawling(ticker)

    p "#{quantity} ações de #{stock.name} (#{ticker}) CNPJ #{stock.cnpj} com custo médio compra de R$#{average_price.round(2)}. Total de R$ #{total.round(2)}"
end

p "------------------------------"
p ">>> IR Bens e Direitos <<<"

p "Grupo 7 - Fundos"

p "Código 3 - Fundos de Investimentos Imobiliários"

fii_crawler = Crawler::Fiis.new

grouped_fiis = operations.select { |t|  t.op == "compra"} .select { |t|  t.type == "fii"} .group_by{ |t| t.name }.values

grouped_fiis.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    total = group.map {|g| g.quantity.to_i * g.value.to_f}.sum
    average_price = total / quantity

    fii = fii_crawler.crawling(ticker)
    p "#{quantity} cotas do #{fii.name} (#{ticker}) CNPJ #{fii.cnpj} com custo médio compra de R$#{average_price.round(2)}. Total de R$ #{total.round(2)}"
end

p "------------------------------"
p ">>> IR Bens e Direitos <<<"

p "Grupo 4 - Aplicações e Investimentos"

p "Código 4 - Ativos negociados em Bolsa (BDRs"

grouped_bdrs = operations.select { |t|  t.op == "compra"} .select { |t|  t.type == "bdr"} .group_by{ |t| t.name }.values
grouped_bdrs.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    total = group.map {|g| g.quantity.to_i * g.value.to_f}.sum
    average_price = total / quantity

    p "#{quantity} BDRs de #{ticker} com custo médio compra de R$#{average_price.round(2)}. Total de R$ #{total.round(2)}"
end