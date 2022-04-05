require 'nokogiri'
require 'open-uri'
require './fii.rb'
require './stock.rb'

module Crawler

  class Fiis

    def crawling(ticker)
        url = "https://statusinvest.com.br/fundos-imobiliarios/#{ticker}"
        site = Nokogiri::HTML(URI.open(url))

        name = site.xpath('//*[@id="main-header"]/div[2]/div/div[1]/h1/small').text
        value = site.xpath('//*[@id="main-2"]/div[2]/div[1]/div[1]/div/div[1]/strong').text
        dy = site.xpath('//*[@id="main-2"]/div[2]/div[1]/div[4]/div/div[1]/strong').text
        dy_value = site.xpath('//*[@id="main-2"]/div[2]/div[1]/div[4]/div/div[2]/div/span[2]').text
        vp_cota = site.xpath('//*[@id="main-2"]/div[2]/div[5]/div/div[1]/div/div[1]/strong').text
        p_vp = site.xpath('//*[@id="main-2"]/div[2]/div[5]/div/div[2]/div/div[1]/strong').text
        cnpj = site.xpath('//*[@id="fund-section"]/div/div/div[2]/div/div[1]/div/div/strong').text

        Fii.new(ticker, name, value, dy, dy_value, vp_cota, p_vp, cnpj, url)
    end

  end

  class Stocks

    def crawling(ticker)
      url = "https://statusinvest.com.br/acoes/#{ticker}"
      site = Nokogiri::HTML(URI.open(url))
  
      name = site.xpath('//*[@id="main-header"]/div[2]/div/div[1]/h1/small').text
      value = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[1]/div/div[1]/strong').text
      dy = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[4]/div/div[1]/strong').text
      dy_value = site.xpath('//*[@id="main-2"]/div[2]/div/div[1]/div/div[4]/div/div[2]/div/span[2]').text      
      dy_value_f = dy_value.gsub("R$ ", "").gsub(",", ".").to_f
      cnpj = site.xpath('//*[@id="company-section"]/div[1]/div/div[1]/div[2]/h4/small').text

      Stock.new(ticker, name, value, dy, dy_value, dy_value_f, cnpj, url)
    end

  end

end
