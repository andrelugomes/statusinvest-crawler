require 'nokogiri'
require 'open-uri'

class Stock

    def initialize(ticker, name, value, dy, dy_value, dy_value_f, cnpj, url)
        @ticker = ticker
        @name = name
        @value = value
        @dy = dy
        @dy_value = dy_value
        @dy_value_f = dy_value_f
        @cnpj = cnpj
        @url = url
    end

    def print
        puts "#{@name}[#{@ticker}] R$ #{@value}"
        puts "DY #{@dy}%"
        puts "ÚLTIMOS 12 MESES #{@dy_value} / ação"
    
        
        puts @dy_value_f
    
        puts "Preço Teto #{@dy_value_f / 0.06}"
        puts @url
        puts "\n"

    end

    def name
        @name
    end

    def cnpj
        @cnpj
    end

end
