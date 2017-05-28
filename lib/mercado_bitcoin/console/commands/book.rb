class MercadoBitcoin::Console::Commands::Book < MercadoBitcoin::Console::Commands::Base
  short_desc 'book operations'

  def after_initialize
    add_command(List.new(console))
  end

  class List < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'list_orderbook'
    long_desc 'Retorna uma lista de até 200 ordens, de acordo com os filtros informados, ordenadas pela data de última atualização. As operações executadas de cada ordem também são retornadas. Apenas ordens que pertencem ao proprietário da chave da TAPI são retornadas. Caso nenhuma ordem seja encontrada, é retornada uma lista vazia.'

    def after_initialize
      options do |opts|
        opts.on("--[no-]full", "Indica quantidades de ordens retornadas no livro.") do |v|
          console.options[:full] = v
        end
      end
    end
  end
end