class MercadoBitcoin::Console::Commands::Account::Withdraw::LTC < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  short_desc 'withdrawal_coin'
  long_desc 'Saques de LTC'

  def after_initialize
    argument_desc(quantity: 'Valor bruto do saque.', address: 'Endereço Litecoin marcado como confiável')
  end

  def execute(quantity, address)
    super(coin: 'ltc', quantity: quantity, address: address)
  end
end
