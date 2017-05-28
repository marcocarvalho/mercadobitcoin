class MercadoBitcoin::Console::Commands::Order::Cancel < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  short_desc 'cancel_order'
  long_desc 'Retorna uma lista de até 200 ordens, de acordo com os filtros informados, ordenadas pela data de última atualização. As operações executadas de cada ordem também são retornadas. Apenas ordens que pertencem ao proprietário da chave da TAPI são retornadas. Caso nenhuma ordem seja encontrada, é retornada uma lista vazia.'

  def after_initialize
    argument_desc(order_id: 'Número de identificação único da ordem por coin_pair.')
  end

  def execute(order_id)
    super
  end
end