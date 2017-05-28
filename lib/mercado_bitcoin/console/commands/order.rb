class MercadoBitcoin::Console::Commands::Order < MercadoBitcoin::Console::Commands::Base
  short_desc 'order operations'

  def after_initialize
    add_command(List.new(console))
    add_command(Get.new(console))
    add_command(Cancel.new(console))
    add_command(Buy.new(console))
    add_command(Sell.new(console))
  end
end

Dir[File.expand_path('../order/*.rb', __FILE__)].each do |file|
  require file
end