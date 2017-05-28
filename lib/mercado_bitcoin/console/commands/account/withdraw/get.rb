class MercadoBitcoin::Console::Commands::Account::Withdraw::Get < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
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