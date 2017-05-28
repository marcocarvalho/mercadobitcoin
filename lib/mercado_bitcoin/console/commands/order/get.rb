class MercadoBitcoin::Console::Commands::Order::Get < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  short_desc 'get_order'
  long_desc 'Retorna os dados da ordem de acordo com o ID informado. Dentre os dados estão as informações das Operações executadas dessa ordem. Apenas ordens que pertencem ao proprietário da chave da TAPI pode ser consultadas. Erros específicos são retornados para os casos onde o order_id informado não seja de uma ordem válida ou pertença a outro usuário.'

  def after_initialize
    argument_desc(order_id: 'Número de identificação único da ordem por coin_pair.')
  end

  def execute(order_id)
    super
  end
end