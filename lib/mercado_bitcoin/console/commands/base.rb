class MercadoBitcoin::Console::Commands::Base < CmdParse::Command
  class << self
    def inherited(klass)
      (@klasses ||= []) << klass
    end

    def command_classes
      @command_classes ||= @klasses.select do |klass|
        !(klass.to_s =~ /Base/) && klass.to_s.split('::').count == 4
      end
    end

    def short_desc(*args)
      if args.count > 0
        @short_desc = args.first
      end
      @short_desc
    end

    def long_desc(*args)
      if args.count > 0
        @long_desc = args.first
      end
      @long_desc
    end

    def take_commands(*args)
      if args.count > 0
        @take_commands = args.first
      end
      @take_commands.nil? ? true : @take_commands
    end
  end

  attr_accessor :console

  def initialize(console)
    @console = console
    super(self.class.to_s.split('::').last.downcase, takes_commands: take_commands)
    self.short_desc = self.class.short_desc
    self.long_desc = self.class.long_desc
    after_initialize
  end

  def take_commands
    self.class.take_commands
  end

  def after_initialize
  end

  def execute(*args)
    console.exec short_desc, args
  end
end