class Environment
  attr_reader :frame, :label, :outer_env, :children

  def initialize(frame, outer_env=nil)
    @frame = frame
    @label = Hash.new
    @outer_env = outer_env
    @children = []
    if outer_env
      outer_env.children << self
    end

  end

  def self.global_env
    Environment.new :car => lambda{|lat| lat[0]},
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
  end

  def env_binding(var) # the environment that binds variable var
    frame.has_key?(var) ? self : outer_env.env_binding(var)
  end

  def printable?(x)
    ![:define, :set!, :lambda].include?(x[0])
  end

  def evaluate(x)
    return env_binding(x).frame[x] if x.is_a? Symbol # x is a variable

    #return x if not x.is_a? Array # x is an atom
    if x.is_a? Array
    case x[0]
      when :define
        frame[x[1]] = evaluate(x[2])
        label[x[1]] = x[2]                
      when :lambda
        lambda{ |*args| Environment.new(Hash[x[1].zip(args)], self).evaluate(x[2]) }
      when :if
        evaluate(x[1]) ? evaluate(x[2]) : evaluate(x[3])
      when :quote 
        x[1]
      when :begin
        result = nil
        for exp in x.drop(1) do
          result = evaluate(exp)
        end
        result
      when :set!
        if env_binding(x[1])
          env_binding(x[1]).frame[x[1]] = evaluate(x[2])
          env_binding(x[1]).label[x[1]] = x[2]
        else
          ". . . oops, #{x[1]} can't be set as it isn't defined"
        end
      else
        values = x.map{ |exp| evaluate(exp) }
        values[0].call(*values.drop(1))        
    end
    else x # x is an atom
    end
  end

end