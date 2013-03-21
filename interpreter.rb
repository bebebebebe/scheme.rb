class Environment
  attr_reader :frame, :outer_env

  def initialize(frame, outer_env=nil)
    @frame = frame
    @outer_env = outer_env
  end

  def self.testing
    env = Environment.new(Hash.new)
  end

  def self.global_env
    Environment.new({:car => lambda{|lat| lat[0]},
                    :cdr => lambda{|lat| lat.drop(1)},
                    :+ => lambda{|x,y| x + y},
                    :* => lambda{|x,y| x * y},
                    :pi => 3.14159
                     
                     })
  end


  # env_binding(x).frame[x]
  # env_binding(:+).frame[:+] = lambda{|x, y| x.send(:+, y)}

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
      when :define then frame[x[1]] = value(x[2]); return nil
      when :lambda
        _, vars, exp = x
        lambda{ |*args|  }
      else values = x.map{ |exp| value(exp) }
          values[0].call(*values.drop(1))
    end
  end

end


module Parser

  def self.parse(scheme_string)
    self.read_from(self.tokenize(scheme_string))
  end

  def self.tokenize(scheme_string) # turn scheme input string into array of tokens
    scheme_string.gsub('(', ' ( ').gsub(')', ' ) ').split
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
    print "schemer.b> "
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

# env = Environment.global_env
# input = "(+ 2 3)"
# puts Parser.parse(input).inspect
# puts env.value(Parser.parse(input))


#string1 = "(define x 5)"
#string2 = "(define x (+ 2 3))"
# tokens1 = Reading.tokenize(string1)
# tokens2 = Reading.tokenize(string2)
# read1 = Reading.read_from tokens1
# read2 = Reading.read_from tokens2
# puts "tokens for #{string1}: "
# puts Reading.tokenize(string1).inspect
# puts "tokens for #{string2}: #{tokens2}"
# puts "output1: #{read1}"
# puts "output2: #{read2}"

# puts "*****"
#puts Reading.parse(string1).inspect
#puts Reading.parse(string2).inspect


# tokens = ["(", "define", "x", "(", "+", "2", "3", ")"]
# #puts Reading.read_from(tokens) == [:define, :x, [:+, 2, 3]]
# puts tokens2.join(", ")
# puts "***"
# puts tokens.join(", ")
# puts Reading.tokenize("(define x 5)").inspect
# puts Reading.tokenize(string1).inspect


# env2 = Environment.new({'y' => 2}, env1)
# env3 = Environment.new({'x' => 3}, env2)
# puts "value of x in env1: #{env1.value('x')}"
# puts "value of x in env2: #{env2.value('x')}"
# puts "value of x in env3: #{env3.value('x')}"
# puts "value of y in env3: #{env3.value('y')}"