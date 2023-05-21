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

#operacoes.csv desde o começo até 31/12/2022
#0,1,2,3,4,5,6,7,8
#Nome,Ticker,Preço,Quantidade,Operação,Data,Papel
#COPEL,CPLE6,7.56,100,compra,"December 21, 2022",stock
#Suno FoF,SNFF11,86.4,4,compra,"December 20, 2022",fii

operations = []

CSV.foreach('temp/Operações 7518cf4fef61425ca047c0f47b1c9fc5.csv', headers: true).with_index do |row, i|
    operations << Ticker.new(row[1], row[2], row[3], row[4], row[6])
end

p ">>> IR Bens e Direitos <<<"

p "Grupo 3 - participações Societárias"

p "Código 1 - Ações"

stock_crawler = Crawler::Stocks.new

stocks_sold = {}
stockssold = operations.select { |t|  t.op == "venda"} .select { |t|  t.type == "stock"} .group_by{ |t| t.name }.values
stockssold.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    stocks_sold[ticker] = quantity
end
p stocks_sold


stocks_bought = operations.select { |t|  t.op == "compra"} .select { |t|  t.type == "stock"} .group_by{ |t| t.name }.values

stocks_bought.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum 
    total = group.map {|g| g.quantity.to_i * g.value.to_f}.sum
    average_price = total / quantity

    stock = stock_crawler.crawling(ticker)

    quantity_sold = stocks_sold[ticker]? stocks_sold[ticker] : 0
    actual = quantity - quantity_sold
    actual_total = actual * average_price

    p "#{actual} ações de #{stock.name} (#{ticker}) CNPJ #{stock.cnpj} com custo médio compra de R$#{average_price.round(2)}. Total de R$ #{actual_total.round(2)}"
end

p "------------------------------"
p ">>> IR Bens e Direitos <<<"

p "Grupo 7 - Fundos"

p "Código 3 - Fundos de Investimentos Imobiliários"

fii_crawler = Crawler::Fiis.new

grouped_fiis = operations.select { |t|  t.op == "compra" || t.op == "subscrição"} .select { |t|  t.type == "fii"} .group_by{ |t| t.name }.values

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

bdrs_sold = {}
bdrssold = operations.select { |t|  t.op == "venda"} .select { |t|  t.type == "bdr"} .group_by{ |t| t.name }.values
bdrssold.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    bdrs_sold[ticker] = quantity
end
p bdrs_sold

grouped_bdrs = operations.select { |t|  t.op == "compra" || t.op == "transferência"} .select { |t|  t.type == "bdr"} .group_by{ |t| t.name }.values
grouped_bdrs.each do | group |
    ticker = group.first.name
    quantity = group.map {|g| g.quantity.to_i}.sum
    total = group.map {|g| g.quantity.to_i * g.value.to_f}.sum
    average_price = total / quantity

    quantity_sold = bdrs_sold[ticker]? bdrs_sold[ticker] : 0
    actual = quantity - quantity_sold
    actual_total = actual * average_price

    p "#{actual} BDRs de #{ticker} com custo médio compra de R$#{average_price.round(2)}. Total de R$ #{actual_total.round(2)}"
end