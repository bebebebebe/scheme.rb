class Environment
  attr_reader :frame, :label, :outer_env, :children

  class UnboundVariable < StandardError; end

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
    Environment.new :car  => lambda {|lat| lat[0]},
                    :cdr  => lambda {|lat| lat.drop(1)},
                    :cons => lambda {|a, lat| [a] + lat},
                    :+    => lambda {|x,y| x + y},
                    :-    => lambda {|x,y| x - y},
                    :*    => lambda {|x,y| x * y},
                    :/    => lambda {|x,y| x / y},
                    :**   => lambda {|x,y| x ** y},
                    :"="  => lambda {|x,y| x == y},
                    :">"  => lambda {|x,y| x > y},
                    :"<"  => lambda {|x,y| x < y}
  end

  def env_binding(var) # the environment that binds variable var
    if frame.has_key?(var)
      self
    elsif outer_env
      outer_env.env_binding(var)
    else
      raise UnboundVariable, "The variable `#{var}' has no value in this context!"
    end
  end

  def printable?(x)
    ![:define, :set!, :lambda].include?(x[0])
  end

  def value(x)
    return env_binding(x).frame[x] if x.is_a? Symbol # x is a variable
    return x if not x.is_a? Array # x is an atom
    case x[0]
      when :define
        frame[x[1]] = value(x[2])
        label[x[1]] = x[2]                
      when :lambda
        lambda{ |*args| Environment.new(Hash[x[1].zip(args)], self).value(x[2]) }
      when :if
        value(x[1]) ? value(x[2]) : value(x[3])
      when :quote 
        x[1]
      when :begin
        ret = nil
        for exp in x.drop(1) do
          ret = value(exp)
        end 
        ret
      when :set!
        begin
          env_binding(x[1]).frame[x[1]] = value(x[2])
          env_bindings(x[1]).label[x[1]] = x[2]
        rescue UnboundVariable
          ". . . oops, #{x[1]} can't be set as it isn't defined"
        end
      else
        values = x.map{ |exp| value(exp) }
        values[0].call(*values.drop(1))        
    end
  end

end
