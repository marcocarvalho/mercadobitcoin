class MercadoBitcoin::Console::Commands::Order::List < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
  StatusList = ['open', 'cancelled', 'filled', 2, 3, 4]
  StatusListHelper = "lista separada por virgulas: (open|2)|(cancelled|3)|(filled|4) default: open"

  short_desc 'list_orders'
  long_desc 'Retorna uma lista de até 200 ordens, de acordo com os filtros informados, ordenadas pela data de última atualização. As operações executadas de cada ordem também são retornadas. Apenas ordens que pertencem ao proprietário da chave da TAPI são retornadas. Caso nenhuma ordem seja encontrada, é retornada uma lista vazia.'

  def after_initialize
    options do |opts|
      opts.on("--order-type [BUY_SELL_OR_CODE]", ['buy', 'sell', '1', '2'], "tipo de ordem, (BUY | SELL | 1 | 2), sem default") do |v|
        console.options[:order_type] = v
      end

      opts.on("--status-list [STATUS_LIST]", StatusList, StatusListHelper) do |v|
        console.options[:status_list] = v
      end

      opts.on("--[no-]has-fills", "Filtro para ordens com ou sem execução") do |v|
        console.options[:has_fills] = v
      end

      opts.on("--from-id [FROM_ID]", "Filtro para orders a partir do ID informado (inclusive).") do |v|
        console.options[:from_id] = v
      end

      opts.on("--to-id [TO_ID]", "Filtro para orders até do ID informado (inclusive).") do |v|
        console.options[:to_id] = v
      end

      opts.on("--from-timestamp [FROM_TIMESTAMP]", "Filtro para orders criadas a partir do timestamp informado (inclusive).") do |v|
        console.options[:from_timestamp] = v
      end

      opts.on("--to-timestamp [TO_TIMESTAMP]", "Filtro para orders criadas até do timestamp informado (inclusive).") do |v|
        console.options[:to_timestamp] = v
      end
    end

    argument_desc(kind_list: StatusListHelper)
  end

  def execute(*args)
    if(args.count > 0)
      console.options[:status_list] = (StatusList & args).uniq.join(',')
    end
    console.exec short_desc, console.options
  end
end
