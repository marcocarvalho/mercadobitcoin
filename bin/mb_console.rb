#!/usr/bin/env ruby

require 'bundler'
require 'json'
Bundler.setup

require 'byebug'
require 'pry'
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
        list_system_messages         - Método para comunicação de eventos do sistema relativos à TAPI
        get_account_info             - Retorna dados da conta, como saldos e limites
        get_order ORDER_ID           - Retorna os dados da ordem de acordo com o ID informado.
        place_buy_order              -
        place_sell_order             -
        cancel_order ORDER_ID        - cancelar orderm de compra/venda
        get_withdrawal WITHDRAWAL_ID - Retorna os dados de uma retirada de moeda digital (BTC, LTC) ou de um saque de Real (BRL).
        withdraw_coin                - Executa a retirada de moedas digitais ou saques de Real. Assim, caso o valor de coin seja
                                       BRL, então realiza um saque para a conta bancária informada. Caso o valor seja BTC ou LTC,
                                       realiza uma transação para o endereço de moeda digital informado em destiny.
  USAGE

  opts.on("-k", "--api-key [MB_API_KEY]", "api key") do |v|
    options[:code] = v
  end

  opts.on("-s", "--secret-key [MB_SECRET_KEY]", "secret key") do |v|
    options[:key] = v
  end

  opts.on("--coin-pair [MB_COIN_PAIR]", [:btc, :ltc, :brl], "coin_pair (btc | ltc | brl), padrão: btc") do |v|
    options[:coin_pair] = v
  end

  opts.on("--[no-]pretty-print", "Mostra (ou não) o json de saida formatado, saída formatada é a default") do |v|
    options[:pretty_print] = v
  end

  opts.on("--order-type [BUY_SELL_OR_CODE]", [:buy, :sell, 1, 2], "tipo de ordem, (BUY | SELL | 1 | 2), sem default") do |v|
    options[:order_type] = v
  end

  opts.on("--status-list [STATUS_LIST]", [:open, :cancelled, :filled, 2, 3, 4], "lista separada por virgulas: (open|2)|(cancelled|3)|(filled|4)") do |v|
    options[:status_list] = v
  end

  opts.on("--[no-]has-fills", "Filtro para ordens com ou sem execução") do |v|
    options[:has_fills] = v
  end

  opts.on("--from-id [FROM_ID]", "Filtro para orders a partir do ID informado (inclusive).") do |v|
    options[:from_id] = v
  end

  opts.on("--to-id [TO_ID]", "Filtro para orders até do ID informado (inclusive).") do |v|
    options[:to_id] = v
  end

  opts.on("--from-timestamp [FROM_TIMESTAMP]", "Filtro para orders criadas a partir do timestamp informado (inclusive).") do |v|
    options[:from_timestamp] = v
  end

  opts.on("--to-timestamp [TO_TIMESTAMP]", "Filtro para orders criadas até do timestamp informado (inclusive).") do |v|
    options[:to_timestamp] = v
  end

  opts.on("--[no-]full", "Indica quantidades de ordens retornadas no livro.") do |v|
    options[:full] = v
  end

  opts.on("--limit-price [PRICE]", "preço limite para compra ou venda") do |v|
    options[:limit_price] = v
  end

  opts.on("--quantity [QUANTITY]", "quantidade de moeda digital para compra/venda") do |v|
    options[:quantity] = v
  end

  opts.on("--destiny [DESTINY]", "Caso o valor de coin seja BRL, informar o ID de uma conta bancária já cadastrada e marcada como confiável. Caso o valor seja BTC ou LTC, informar um endereço marcado como confiável , Bitcoin ou Litecoin, respectivamente.") do |v|
    options[:destiny] = v
  end

  opts.on("--description [DESCRIPTION]", "Texto livre para auxiliar o usuário a relacionar a retirada/saque com atividades externas.") do |v|
    options[:description] = v
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

  def get_order(*args)
    raise ArgumentError.new("faltando ORDER_ID") if args.count < 1
    ret = args.map do |id|
      trade_api.get_order(order_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
  end

  def list_orders(*args)
    trade_api.list_orders(
      coin_pair: options[:coin_pair],
      order_type: options[:order_type],
      status_list: options[:status_list],
      has_fills: options[:has_fills],
      from_id: options[:from_id],
      to_id: options[:to_id],
      from_timestamp: options[:from_timestamp],
      to_timestamp: options[:to_timestamp])
  end

  def list_orderbook(*args)
    trade_api.list_orderbook(
      coin_pair: options[:coin_pair],
      full: options[:full]
    )
  end

  def place_buy_order(*args)
    trade_api.place_buy_order(
      coin_pair: params[:coin_pair],
      quantity: params[:quantity],
      limit_price: params[:limit_price]
    )
  end

  def place_sell_order(*args)
    trade_api.place_sell_order(
      coin_pair: params[:coin_pair],
      quantity: params[:quantity],
      limit_price: params[:limit_price]
    )
  end

  def cancel_order(*args)
    raise ArgumentError.new("faltando ORDER_ID") if args.count < 1
    ret = args.map do |id|
      trade_api.cancel_order(coin_pair: params[:coin_pair], order_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
  end

  def get_withdrawal(*args)
    raise ArgumentError.new("faltando withdrawal_id") if args.count < 1
    ret = args.map do |id|
      trade_api.get_withdrawal(coin_pair: params[:coin_pair], withdrawal_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
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

begin
  MercadoBitcoin::Console.new(options).exec(command, ARGV)
rescue ArgumentError => e
  puts "\n\nFaltando argumentos para o comando #{command}\n\n"
  puts opt_parser
  exit(-2)
rescue RestClient::ServiceUnavailable => e
  puts "Server returned 503 - Service Unavailable"
  exit(-503)
end
