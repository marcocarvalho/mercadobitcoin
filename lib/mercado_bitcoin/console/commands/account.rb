class MercadoBitcoin::Console::Commands::Account < MercadoBitcoin::Console::Commands::Base
  short_desc 'account operations'

  def after_initialize
    add_command(Info.new(console))
    add_command(Withdraw.new(console))
  end

  def execute(*args)
  end

  class Withdraw < MercadoBitcoin::Console::Commands::Base
    short_desc 'withdraw'

    def after_initialize
      add_command(Get.new(console))
      add_command(BTC.new(console))
      add_command(BRL.new(console))
      add_command(LTC.new(console))
      options do |opts|
        opts.on("--description [DESCRIPTION]", "Texto livre para auxiliar o usuário a relacionar a retirada/saque com atividades externas.") do |v|
          console.options[:description] = v
        end
      end
    end

    class BRL < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
      short_desc 'withdrawal_coin'
      long_desc 'Saques de Real'

      def after_initialize
        argument_desc(quantity: 'Valor bruto do saque.', account_ref: 'ID de uma conta bancária já cadastrada e marcada como confiável')
      end

      def execute(quantity, account_ref)
        super(coin: 'brl', quantity: quantity, account_ref: account_ref)
      end
    end

    class BTC < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
      short_desc 'withdrawal_coin'
      long_desc 'Saques de BTC'

      def after_initialize
        argument_desc(quantity: 'Valor bruto do saque.', address: 'Endereço Bitcoin marcado como confiável')
        options do |opts|
          opts.on("--[no-]tx-aggregate", "retirada pode ser feita junto de outras retiradas em uma mesma transação no Blockchain.") do |v|
            console.options[:tx_aggregate] = v
          end
          opts.on("--[no-]via-blockchain", "retirada para endereço no Mercado Bitcoin pode ser feita via Blockchain para gerar uma transação na rede Bitcoin.") do |v|
            console.options[:via_blockchain] = v
          end
        end
      end

      def execute(quantity, address)
        super(coin: 'btc', quantity: quantity, address: address)
      end
    end

    class LTC < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
      short_desc 'withdrawal_coin'
      long_desc 'Saques de LTC'

      def after_initialize
        argument_desc(quantity: 'Valor bruto do saque.', address: 'Endereço Litecoin marcado como confiável')
      end

      def execute(quantity, address)
        super(coin: 'ltc', quantity: quantity, address: address)
      end
    end

    class Get < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
      short_desc 'get_withdrawal'
      long_desc 'Retorna os dados de uma retirada de moeda digital (BTC, LTC) ou de um saque de Real (BRL).'

      def after_initialize
        argument_desc(withdraw_id: 'Número de identificação da retirada/saque, único por coin.', coin: 'BRL|BTC|LCT')
      end

      def execute(coin, withdraw_id)
        console.options[:coin_pair] = coin
        super(withdraw_id)
      end
    end
  end

  class Info < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'get_account_info'
    long_desc  'Retorna dados da conta, como saldos das moedas (Real, Bitcoin e Litecoin), saldos considerando retenção em ordens abertas, quantidades de ordens abertas por moeda digital, limites de saque/retirada das moedas.'
  end
end