GRAPH = Hash.new

module Graph
  def self.children(env) # frames of children in GRAPH
    array = []
    GRAPH[env].each { |child| array << child.frame}
    array
  end

end

##################### above: for app. also: two lines in Environment.initialize

class Environment
  attr_reader :frame, :outer_env, :user_input

  def initialize(frame, outer_env=nil)
    @frame = frame
    @outer_env = outer_env

    GRAPH[self] = []
    (GRAPH[outer_env] << self) if outer_env

  end

  def self.global_env
    Environment.new({:car => lambda{|lat| lat[0]},
                    :cdr => lambda{|lat| lat.drop(1)},
                    :cons => lambda{|a, lat| [a] + lat},
                    :+ => lambda{|x,y| x + y},
                    :- => lambda{|x,y| x - y},
                    :* => lambda{|x,y| x * y},
                    :/ => lambda{|x,y| x / y},
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

  def value(x)  
    return env_binding(x).frame[x] if x.is_a? Symbol # x is a variable
    return x if not x.is_a? Array # x is an atom
    case x[0]
      when :define then frame[x[1]] = value(x[2])
      when :lambda
        lambda{ |*args| Environment.new(Hash[x[1].zip(args)], self).value(x[2]) }
      when :if
        value(x[1]) == true ? value(x[2]) : value(x[3])
      when :quote then x[1]
      when :begin
        for exp in x.drop(1) do
          value(exp)
        end
        value(x.last)
      when :set! 
        begin
          env_binding(x[1]).frame[x[1]] = value(x[2])
        rescue 
          ". . . oops, #{x[1]} can't be set as it isn't defined"
        end
      # when :write
      #   @user_input = x[1..-1].join(" ")     
      else values = x.map{ |exp| value(exp) }
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
  attr_reader :input, :env

  def initialize
   @env = Environment.global_env
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

  def printing
    puts Parser.to_scheme(@value)
  end
  
end






#env = Environment.new({ x:5 })
    #exp = [:begin, [:+, 2, 3], [:+, 10, 2]]
#puts env1.value([:+, 10, 2])
#input = "(+ 1 2)"

#env = Environment.global_env
#input = "(+ 1 2)"
#  input = "(begin (define x 5) (+ x 2))"

#   #input = "(if (= 2 1) 0 (if (= 1 1) 1 2)) "
# #  #input = "(cons 0 (quote (1 2 3)))"
# # input = "(quote (1 2 3))"
# # #input = "(if (= 5 5) (if (= 1 1) 1 2))"
#    x = Parser.parse(input)
#    puts x == [:+, 1, 2]

   # val = env.value(Parser.parse(input))
 #puts val.inspect
  # puts Parser.to_scheme(env.value(Parser.parse(input)))

