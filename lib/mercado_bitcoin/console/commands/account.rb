class MercadoBitcoin::Console::Commands::Account < MercadoBitcoin::Console::Commands::Base
  short_desc 'account operations'

  def after_initialize
    add_command(Info.new(console))
    add_command(Withdraw.new(console))
  end

  def execute(*args)
  end

  class Info < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'get_account_info'
    long_desc  'Retorna dados da conta, como saldos das moedas (Real, Bitcoin e Litecoin), saldos considerando retenção em ordens abertas, quantidades de ordens abertas por moeda digital, limites de saque/retirada das moedas.'
  end
end

require 'mercado_bitcoin/console/commands/account/withdraw'