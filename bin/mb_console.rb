#!/usr/bin/env ruby

require 'pry'
require 'bundler'
require 'json'
Bundler.setup

require 'dotenv'
Dotenv.load

require 'mercado_bitcoin'


def options
  @options ||= {
    key: ENV['MB_API_KEY'],
    code: ENV['MB_SECRET_KEY'],
    coin_pair: ENV['MB_COIN_PAIR'] || 'btc',
    pretty_print: true
  }
end

opt_parser = OptionParser.new do |opts|
  opts.banner = <<-USAGE.gsub(/^    /, '')
    Usage: #{File.basename(__FILE__)} [options] command [command_options]
      Pode-se usar variáveis de ambiente ou
      setá-las em um arquivo .env. As variáveis disponíveis são:
        MB_API_KEY
        MB_SECRET_KEY
        MB_COIN_PAIR (padrão: btc)

      Comandos (mais informações em https://www.mercadobitcoin.com.br/trade-api/):
        list_system_messages - Método para comunicação de eventos do sistema relativos à TAPI
        get_account_info     - Retorna dados da conta, como saldos e limites
        get_order ORDER_ID   - Retorna os dados da ordem de acordo com o ID informado.

  USAGE

  opts.on("-k", "--api-key [MB_API_KEY]", "api key") do |v|
    options[:code] = v
  end

  opts.on("-s", "--secret-key [MB_SECRET_KEY]", "secret key") do |v|
    options[:key] = v
  end

  opts.on("--coin_pair [MB_COIN_PAIR]", [:btc, :ltc], "coin_pair (btc | ltc), padrão: btc") do |v|
    options[:coin_pair] = v
  end

  opts.on("--[no-]pretty-print", "Mostra (ou não) o json de saida formatado, saída formatada é a default") do |v|
    options[:pretty_print] = v
  end

  opts.on('-h', '--help') do
    puts opts
    exit(0)
  end
end

opt_parser.parse!

if(ARGV.count < 1)
  puts opt_parser
  exit(-1)
end

class MercadoBitcoin::Console
  attr_accessor :options

  # Laizy way to check parameters :)
  def initialize(key:, code:, coin_pair:, **opts)
    @options = opts || {}
    @options[:key]          = key
    @options[:code]         = code
    @options[:coin_pair]    = coin_pair
  end

  def exec(command, opts)
    print send(command, *opts)
  end

  def list_system_messages(*args)
    trade_api.list_system_messages
  end

  def get_account_info(*args)
    trade_api.get_account_info
  end

  private

  def print(value)
    if pretty_print?
      Pry::ColorPrinter.pp value
    else
      puts value.to_json
    end
  end

  def pretty_print?
    @options[:pretty_print]
  end

  def trade_api
    @trade_api ||= MercadoBitcoin::TradeApi.new(
      key: options[:key],
      code: options[:code]
    )
  end
end

command = ARGV.shift

MercadoBitcoin::Console.new(options).exec(command, ARGV)
