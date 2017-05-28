class MercadoBitcoin::Console::Commands::Account::Withdraw::BTC < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
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