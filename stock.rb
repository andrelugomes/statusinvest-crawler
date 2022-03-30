require 'nokogiri'
require 'open-uri'

class Stock

    def crawling(ticker)
        url = "https://statusinvest.com.br/acoes/#{ticker}"
        site = Nokogiri::HTML(URI.open(url))
    
        name = site.xpath('//*[@id="main-header"]/div[2]/div/div[1]/h1/small')
        value = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[1]/div/div[1]/strong')
        dy = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[4]/div/div[1]/strong')
        dy_value = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[4]/div/div[2]/div/span[2]')
    
        puts "#{name.text}[#{ticker}] R$ #{value.text}"
        puts "DY #{dy.text}%"
        puts "ÚLTIMOS 12 MESES #{dy_value.text} / ação"
    
        dy_value_f = dy_value.text.gsub("R$ ", "").gsub(",", ".").to_f
        puts dy_value_f
    
        puts "Preço Teto #{dy_value_f / 0.06}"
        puts url
        puts "\n"
    end

end
