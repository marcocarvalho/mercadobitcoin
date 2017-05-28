class MercadoBitcoin::Console::Commands::Order < MercadoBitcoin::Console::Commands::Base
  short_desc 'order operations'

  def after_initialize
    add_command(List.new(console))
    add_command(Get.new(console))
    add_command(Cancel.new(console))
    add_command(Buy.new(console))
    add_command(Sell.new(console))
  end

  class Buy < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'place_buy_order'
    long_desc 'Abre uma ordem de compra (buy ou bid) do par de moedas, quantidade de moeda digital e preço unitário limite informados. A criação contempla o processo de confrontamento da ordem com o livro de negociações. Assim, a resposta pode informar se a ordem foi executada (parcialmente ou não) imediatamente após sua criação e, assim, se segue ou não aberta e ativa no livro.'

    def after_initialize
      argument_desc(quantity: 'Quantidade da moeda digital a comprar/vender ao preço de price. (até 8 decimais, separador decimal: .)'+"\n", price: 'Preço unitário máximo de compra ou mínimo de venda. (até 5 decimais, separador decimal: .)')
    end

    def execute(quantity, price)
      console.options[:quantity] = quantity.to_f
      console.options[:limit_price] = price.to_f
      super
    end
  end

  class Sell < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'place_sell_order'
    long_desc 'Abre uma ordem de venda (sell ou ask) do par de moedas, quantidade de moeda digital e preço unitário limite informados. A criação contempla o processo de confrontamento da ordem com o livro de negociações. Assim, a resposta pode informar se a ordem foi executada (parcialmente ou não) imediatamente após sua criação e, assim, se segue ou não aberta e ativa no livro.'

    def after_initialize
      argument_desc(quantity: 'Quantidade da moeda digital a comprar/vender ao preço de price. (até 8 decimais, separador decimal: .)'+"\n", price: 'Preço unitário máximo de compra ou mínimo de venda. (até 5 decimais, separador decimal: .)')
    end

    def execute(quantity, price)
      console.options[:quantity] = quantity.to_f
      console.options[:limit_price] = price.to_f
      super
    end
  end

  class Cancel < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'cancel_order'
    long_desc 'Retorna uma lista de até 200 ordens, de acordo com os filtros informados, ordenadas pela data de última atualização. As operações executadas de cada ordem também são retornadas. Apenas ordens que pertencem ao proprietário da chave da TAPI são retornadas. Caso nenhuma ordem seja encontrada, é retornada uma lista vazia.'

    def after_initialize
      argument_desc(order_id: 'Número de identificação único da ordem por coin_pair.')
    end

    def execute(order_id)
      super
    end
  end

  class Get < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'get_order'
    long_desc 'Retorna os dados da ordem de acordo com o ID informado. Dentre os dados estão as informações das Operações executadas dessa ordem. Apenas ordens que pertencem ao proprietário da chave da TAPI pode ser consultadas. Erros específicos são retornados para os casos onde o order_id informado não seja de uma ordem válida ou pertença a outro usuário.'

    def after_initialize
      argument_desc(order_id: 'Número de identificação único da ordem por coin_pair.')
    end

    def execute(order_id)
      super
    end
  end

  class List < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
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
end