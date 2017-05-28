module MercadoBitcoin::Console::Commands
  autoload :Base, 'mercado_bitcoin/console/commands/base'
  autoload :BaseNoTakeCommand, 'mercado_bitcoin/console/commands/base_no_take_command'
  autoload :Account, 'mercado_bitcoin/console/commands/account'
  autoload :Order, 'mercado_bitcoin/console/commands/order'
  autoload :System, 'mercado_bitcoin/console/commands/system'
end