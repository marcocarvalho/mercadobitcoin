class MercadoBitcoin::Console::CommandParse
  attr_accessor :console

  class << self
    def parse(console)
      new.parse(console)
    end
  end

  def parse(console)
    @console = console
    parser.add_command(CmdParse::HelpCommand.new, default: true)
    parser.add_command(CmdParse::VersionCommand.new)
    MercadoBitcoin::Console::Commands::Base.command_classes.each do |command|
      parser.add_command(command.new(console))
    end
    global_options
    parser.parse
  end

  def global_options
    parser.global_options do |opts|
      opts.on("-k", "--api-key MB_API_KEY", "api key") do |v|
        console.options[:code] = v
      end

      opts.on("-s", "--secret-key MB_SECRET_KEY", "secret key") do |v|
        console.options[:key] = v
      end

      opts.on("--coin-pair MB_COIN_PAIR", [:brlbtc, :brlltc, :brl], "coin_pair (brlbtc | brlltc | brl), padrão: brlbtc") do |v|
        console.options[:coin_pair] = v.to_s.to_upper
      end

      opts.on("--[no-]pretty-print", "Mostra (ou não) o json de saida formatado, saída formatada é a default") do |v|
        console.options[:pretty_print] = v
      end

      opts.on("--[no-]debug", "debug info printed") do |v|
        console.options[:debug] = v
      end
    end
  end

  def parser
    @parser ||= CmdParse::CommandParser.new.tap do |init|
      init.main_options.program_name = "mb_console"
      init.main_options.version = MercadoBitcoin::VERSION
      init.main_options.banner = "MercadoBitcoin Console"
      init.help_line_width = 160
    end
  end
end