class CommandParser
  class Argument
    attr_accessor :name, :block

    def initialize(name, block)
      @name = name
      @block = block
    end
  end

  class Option
    attr_accessor :short, :long, :help, :block

    def initialize(short, long, help, block)
      @short = '-' + short
      @long = '--' + long
      @help = help
      @block = block
    end

    def named_like?(string)
      string.include?(short) || string.include?(long)
    end

    def param?(string)
      string.include?("=") || ( string[1] != '-' && string.size > 2 )
    end

    def get_param(str)
      return true unless param?(str)
      str.include?("=") ? str.slice!(long + "=") : str.slice!(short)
      str
    end
  end

  class OptionWithParameter < Option
    attr_accessor :parameter

    def initialize(short, long, help, parameter, block)
      super(short, long, help, block)
      @parameter = parameter
    end
  end

  def initialize(command_name)
    @command_name = command_name
    @arguments = []
    @current_argument = 0
    @options = []
  end

  def option?(string)
    string[0] == '-'
  end

  def parse(command_runner, argv)
    argv.each do |elem|
      if option?(elem) && @options.index { |x| x.named_like?(elem) } != nil
        i = @options.index { |x| x.named_like?(elem) }
        @options[i].block.call(command_runner, @options[i].get_param(elem))
      elsif !option?(elem)
        @arguments[@current_argument].block.call(command_runner, elem)
        @current_argument += 1
      end
    end
  end

  def argument(name, &block)
    @arguments.push(Argument.new(name, block))
  end

  def option(short, long, help, &block)
    @options.push(Option.new(short, long, help, block))
  end

  def option_with_parameter(short, long, help, parameter, &block)
    @options.push(OptionWithParameter.new(short, long, help, parameter, block))
  end

  def help
    h = "Usage: #{@command_name}"
    @arguments.each { |x| h = h + ' [' + x.name + ']' }
    @options.each do |x|
      h = h + "\n    " + x.short + ', ' + x.long
      h = h + "=" + x.parameter if x.is_a?(OptionWithParameter)
      h = h + ' ' + x.help
    end
    h
  end
end
