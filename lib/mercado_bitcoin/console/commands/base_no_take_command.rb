  class MercadoBitcoin::Console::Commands::BaseNoTakeCommand < MercadoBitcoin::Console::Commands::Base
    def take_commands
      false
    end
  end