class Fii

    def initialize(ticker, name, value, dy, dy_value, vp, pvp)
        @ticker = ticker
        @name = name
        @value = value
        @dy = dy
        @dy_value = dy_value
        @vp = vp
        @pvp = pvp
        @dy_value_f = dy_value.gsub("R$ ", "").gsub(",", ".").to_f
    end

    def print
        puts "#{@name}[#{@ticker}]"
        puts "P R$ #{@value}"
        puts "VP P/COTA R$ #{@vp}"
        puts "P/VP #{@pvp}"
        puts "DY #{@dy}%"
        puts "ÚLTIMOS 12 MESES #{@dy_value} / cota"
    end

    def print_max_price    
        puts "Preço Teto #{@dy_value_f / 0.06}"
    end 

    def print_earning_vp
        puts "DY/VP #{(@dy_value_f / @vp.gsub("R$ ", "").gsub(",", ".").to_f) * 100} %"
    end
    
    def print_earning_p
        puts "DY/P #{(@dy_value_f / @value.gsub("R$ ", "").gsub(",", ".").to_f) * 100} %"
    end

    def ticker
        @ticker
    end

    def name
        @name
    end

    def value
        @value
    end

    def dy
        @dy
    end

    def dy_value
        @dy_value
    end

    def vp
        @vp
    end

    def pvp
        @pvp
    end

end