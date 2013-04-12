require 'json'

module Tree

  def self.mini(frame) # string. represent bindings to lambdas as bindings to the string "lambda"
    frame2 = frame.dup
    frame2.each { |k,v| if v.class == Proc then frame2[k] = "lambda" end }.to_s
  end  

  def self.structure(vertex)
    {frame: mini(vertex.frame), children: vertex.children.map { |i| structure(i) } }
  end

  def self.label_structure(vertex)
    structure(vertex).merge({ name:"global env" })
  end

end

class Environment
  attr_reader :frame, :outer_env, :children

  def initialize(frame, outer_env=nil)
    @frame = frame
    @outer_env = outer_env
    @children = []
    if outer_env
      outer_env.children << self
    end

  end

  def self.global_env
    Environment.new({:car => lambda{|lat| lat[0]},
                    :cdr => lambda{|lat| lat.drop(1)},
                    :cons => lambda{|a, lat| [a] + lat},
                    :+ => lambda{|x,y| x + y},
                    :- => lambda{|x,y| x - y},
                    :* => lambda{|x,y| x * y},
                    :** => lambda{|x,y| x ** y},
                    :"=" => lambda{|x,y| x == y},
                    :">" => lambda{|x,y| x > y},
                    :"<" => lambda{|x,y| x < y}
   
                     })
  end

  def env_binding(var) # the environment that binds variable var
    if frame.has_key?(var)
      self
    else outer_env.env_binding(var)
    end
  end

  def printable?(x)
    (x[0] != :define) and (x[0] != :set!) and (x[0] != :lambda)
  end

  def value(x)
    if x.is_a? Symbol # x is a variable
      return env_binding(x).frame[x]
    else
    end
    if not x.is_a? Array # x is an atom
      return x
    else
    end
    case x[0]
      when :define
        frame[x[1]] = value(x[2])
                
      when :lambda
        lambda{ |*args| Environment.new(Hash[x[1].zip(args)], self).value(x[2]) }
      when :if
        value(x[1]) == true ? value(x[2]) : value(x[3])
      when :quote 
        x[1]
      when :begin
        for exp in x.drop(1) do
          value(exp)
        end 
          return value(x.last)
      when :set!
        begin
          env_binding(x[1]).frame[x[1]] = value(x[2])
        rescue
          ". . . oops, #{x[1]} can't be set as it isn't defined"
        end
      else
        values = x.map{ |exp| value(exp) }
        values[0].call(*values.drop(1))
        
    end
  end


end


module Parser

  def self.parse(scheme_string)
    self.read_from(self.tokenize(scheme_string))
  end

  def self.tokenize(scheme_string)
    scheme_string.gsub('(', ' ( ').gsub(')', ' ) ').gsub("'", "' ").split
  end

  def self.read_from(tokens)
    raise "empty string!" if tokens.length == 0
    token = tokens.shift
    if token == '('
      l = []
      while tokens.first != ')'
        l.push(read_from(tokens))
      end
       tokens.shift # why do we need this?
      l
    elsif token == ')'
      raise "shouldn't be a right paren"
    else atom(token)
    end    
  end

  def self.atom(token)
    begin 
      Integer(token)
    rescue ArgumentError
      begin 
        Float(token)
      rescue ArgumentError
      token.to_sym
      end
    end
  end

  def self.to_scheme(exp)
    if exp.is_a? Array
      '(' + exp.map{ |x| x.to_s}.join(' ') + ')'
    else exp.to_s
    end
  end

end

class Repl
  attr_reader :input, :env, :root

  def initialize
   @env = Environment.global_env
   @root = env
  end

  def prompt
    print "schemerB> "
  end

  def read
    @input = gets.chomp
  end

  def evaluate
    @value = env.value(Parser.parse(input))
  end

  def print_status(input) # true or false
    env.printable?(Parser.parse(input))    
  end

  def printing
    puts Parser.to_scheme(@value)
  end

  def tree
    Tree.label_structure(root)
    
  end
end

#############      for sinatra app

class ReplActions
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
    Parser.to_scheme(@value)
  end

  def tree
    #treeData = {name: "a", frame: {x:5}, children: [name: "b", frame: {}, children: []]}
    Tree.label_structure(root)
  end

  # def store(input)
  #   input
  # end

end

# repl = ReplActions.new
# input = "(define fact-iter (lambda (product counter max-count) (if (> counter max-count) product (fact-iter (* counter product) (+ counter 1) max-count))))"

# repl.evaluate(input)
# input = "(define factorial (lambda (n) (fact-iter 1 1 n)))"
# input = "(factorial 5)"
# repl.evaluate(input)
# env = Environment.global_env
# input = "(define factorial (lambda (x) (if (= x 0) 1 (* x (factorial (- x 1))))))"
# value = Parser.parse(input)
# puts value.inspect
 # repl.evaluate(input)
 # #repl.tree.to_json
 # input = "(factorial 5)"
 # repl.evaluate(input)


# input = "(define x 5)"
# repl.evaluate(input)
# repl.print_status(input)
# repl.printing


# input = "(+ 2 3)"
# repl.evaluate(input)
# puts repl.tree.to_json
# input = "(+ 1 2)"
# repl.evaluate(input)

# #  input = "(define acc (lambda (start)(lambda (supplement)(set! start (+ start supplement))start)))"
# #  repl.evaluate(input)
# #  input = "(define A (acc 5))"
# #  repl.evalutate(input)
# # input = "(A 10)"
# # repl.evaluate(input)
#  puts repl.tree.to_json
