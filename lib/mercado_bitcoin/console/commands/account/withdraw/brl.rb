class MercadoBitcoin::Console::Commands::Account::Withdraw::BRL < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  short_desc 'withdrawal_coin'
  long_desc 'Saques de Real'

  def after_initialize
    argument_desc(quantity: 'Valor bruto do saque.', account_ref: 'ID de uma conta bancária já cadastrada e marcada como confiável')
  end

  def execute(quantity, account_ref)
    super(coin: 'brl', quantity: quantity, account_ref: account_ref)
  end
end