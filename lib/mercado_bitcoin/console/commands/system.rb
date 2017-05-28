class MercadoBitcoin::Console::Commands::System < MercadoBitcoin::Console::Commands::Base
  short_desc 'system operations'

  def after_initialize
    add_command(Messages.new(console))
  end

  def execute(*args)
  end

  class Messages < MercadoBitcoin::Console::Commands::BaseNoTakeCommand
    short_desc 'list_system_messages'
    long_desc  'Método para comunicação de eventos do sistema relativos à TAPÌ, entre eles bugs, correções, manutenção programada e novas funcionalidades e versões. O conteúdo muda a medida que os eventos ocorrem. A comunicação externa, feita via Twitter e e-mail aos usuários da TAPI, continuará ocorrendo. Entretanto, essa forma permite ao desenvolvedor tratar as informações juntamente ao seus logs ou até mesmo automatizar comportamentos.'
  end
end