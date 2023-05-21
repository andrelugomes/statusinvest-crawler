# statusinvest-crawler

## Install Ruby

https://github.com/asdf-vm/asdf-ruby
https://github.com/rbenv/ruby-build/wiki#suggested-build-environment

```sh
$ sudo apt-get install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
 
$ asdf install ruby 3.0.2
$ asdf global ruby 3.0.2


$ gem install nokogiri
$ gem install spreadsheet
```

## Usage

### Stock
Put all tickers you want line by line in `radar_stocks.txt` file
Put all tickers that you have line by line in `my_stocks.txt` file

```sh
$ ruby stocks.rb -h
```

Or specific tickers by arguments

```sh
$ ruby stocks.rb B3SA3 BBAS3
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