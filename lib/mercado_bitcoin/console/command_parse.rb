class MercadoBitcoin::Console::CommandParse
  attr_accessor :console

  class << self
    def parse(console)
      new.parse(console)
    end
  end

  def parse(console)
    @console = console
    parser.add_command(CmdParse::HelpCommand.new, default: true)
    parser.add_command(CmdParse::VersionCommand.new)
    MercadoBitcoin::Console::Commands::Base.command_classes.each do |command|
      parser.add_command(command.new(console))
    end
    global_options
    parser.parse
  end

  def global_options
    parser.global_options do |opts|
      opts.on("-k", "--api-key MB_API_KEY", "api key") do |v|
        console.options[:code] = v
      end

      opts.on("-s", "--secret-key MB_SECRET_KEY", "secret key") do |v|
        console.options[:key] = v
      end

      opts.on("--coin-pair MB_COIN_PAIR", [:brlbtc, :brlltc, :brl], "coin_pair (brlbtc | brlltc | brl), padrão: brlbtc") do |v|
        console.options[:coin_pair] = v.to_s.to_upper
      end

      opts.on("--[no-]pretty-print", "Mostra (ou não) o json de saida formatado, saída formatada é a default") do |v|
        console.options[:pretty_print] = v
      end

      opts.on("--[no-]debug", "debug info printed") do |v|
        console.options[:debug] = v
      end
    end
  end

  def parser
    @parser ||= CmdParse::CommandParser.new.tap do |init|
      init.main_options.program_name = "mb_console"
      init.main_options.version = MercadoBitcoin::VERSION
      init.main_options.banner = "MercadoBitcoin Console"
    end
  end
end
__END__

  def opt_parser
    @opt_parser ||= OptionParser.new do |opts|
      opts.banner = <<-USAGE.gsub(/^        /, '')
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
            list_orders                  - Retorna uma lista de até 200 ordens, de acordo com os filtros informados, ordenadas pela
                                           data de última atualização. As operações executadas de cada ordem também são retornadas.
            list_orderbook               - Retorna informações do livro de negociações (orderbook) do Mercado Bitcoin para o par de
                                           moedas (coin_pair) informado.
            place_buy_order              - Abre uma ordem de compra (buy ou bid) do par de moedas, quantidade de moeda digital e
                                           preço unitário limite informados.
            place_sell_order             - Abre uma ordem de venda (sell ou ask) do par de moedas, quantidade de moeda digital e
                                           preço unitário limite informados.
            cancel_order ORDER_ID        - cancelar orderm de compra/venda
            get_withdrawal WITHDRAWAL_ID - Retorna os dados de uma retirada de moeda digital (BTC, LTC) ou de um saque de Real (BRL).
            withdraw_coin                - Executa a retirada de moedas digitais ou saques de Real. Assim, caso o valor de coin seja
                                           BRL, então realiza um saque para a conta bancária informada. Caso o valor seja BTC ou LTC,
                                           realiza uma transação para o endereço de moeda digital informado em destiny.
      USAGE

      opts.on("-k", "--api-key MB_API_KEY", "api key") do |v|
        options[:code] = v
      end

      opts.on("-s", "--secret-key MB_SECRET_KEY", "secret key") do |v|
        options[:key] = v
      end

      opts.on("--coin-pair MB_COIN_PAIR", [:brlbtc, :brlltc, :brl], "coin_pair (brlbtc | brlltc | brl), padrão: brlbtc") do |v|
        options[:coin_pair] = v.to_s.to_upper
      end

      opts.on("--[no-]pretty-print", "Mostra (ou não) o json de saida formatado, saída formatada é a default") do |v|
        options[:pretty_print] = v
      end

      opts.on("--[no-]debug", "debug info printed") do |v|
        options[:debug] = v
      end

      opts.on('-h', '--help') do
        puts opts
        exit(0)
      end
    end
  end
end

__END__

  opts.on("--order-type [BUY_SELL_OR_CODE]", ['buy', 'sell', '1', '2'], "tipo de ordem, (BUY | SELL | 1 | 2), sem default") do |v|
    options[:order_type] = v
  end

  opts.on("--status-list [STATUS_LIST]", ['open', 'cancelled', 'filled', 2, 3, 4], "lista separada por virgulas: (open|2)|(cancelled|3)|(filled|4) default: open") do |v|
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
end