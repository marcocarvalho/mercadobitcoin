class MercadoBitcoin::Console::Commands::Ticker < MercadoBitcoin::Console::Commands::Base
  take_commands false
  short_desc 'ticker'
  long_desc 'Retorna as informações do mercado de bitcoin ou litecoin.'
end