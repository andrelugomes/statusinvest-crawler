# statusinvest-crawler

## Install Ruby

```sh
$ sudo apt-get install -y libssl-dev zlib1g-dev

$ asdf install ruby 3.0.2
$ asdf global ruby 3.0.2


$ gem install nokogiri
```

## Usage

Put all tickers you want line by line in `tickers.txt` file

```sh
$ ruby crawling.rb 
```

Or specific tickers by arguments

```sh
$ ruby crawling.rb B3SA3 BBAS3
```