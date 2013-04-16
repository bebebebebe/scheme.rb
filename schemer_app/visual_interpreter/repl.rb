#require_relative 'environment'
#require_relative 'parser'
#require_relative 'tree'

class Repl
  attr_reader :env, :root

  def initialize
    @env = Environment.global_env
    @root = env
  end

  def evaluate(input)
    @value = env.value(Parser.parse(input))
  end

  def print_status(input) # true or false
    env.printable?(Parser.parse(input))
  end

  def printing
    if @value.class == Proc
      to_print = "* procedure *"
    else 
      to_print = Parser.to_scheme(@value)
    end
    to_print
  end

  def tree
    Tree.structure(root)
  end

end