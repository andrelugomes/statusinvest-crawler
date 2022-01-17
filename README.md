# statusinvest-crawler

## Install Ruby

```sh
$ sudo apt-get install -y libssl-dev zlib1g-dev

$ asdf install ruby 3.0.2
$ asdf global ruby 3.0.2


$ gem install nokogiri
$ gem install spreadsheet
```

## Usage

### Stock
Put all tickers you want line by line in `tickers.txt` file

```sh
$ ruby crawling.rb 
```

Or specific tickers by arguments

```sh
$ ruby crawling.rb B3SA3 BBAS3
```

### FIIs
Put all tickers you want line by line in `radar_fiis.txt` file
Put all tickers that you have line by line in `my_fiis.txt` file

```sh
$ ruby fiis.rb -h
```

Or specific tickers by arguments

```sh
$ ruby fiis.rb HGLG11
```