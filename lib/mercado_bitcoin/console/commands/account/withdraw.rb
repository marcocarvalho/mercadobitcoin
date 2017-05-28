class MercadoBitcoin::Console::Commands::Account::Withdraw < MercadoBitcoin::Console::Commands::Base
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
end

Dir[File.expand_path('../withdraw/*.rb', __FILE__)].each do |file|
  require file
end
