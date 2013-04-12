require_relative 'graph_interpreter.rb'
require 'minitest/autorun'

class InterpreterTest < MiniTest::Unit::TestCase

########### Tree module
  def test_structure
    env1 = Environment.new({ x:4 })
    env2 = Environment.new({}, env1)
    env3 = Environment.new({}, env2)
    assert_equal(Tree.structure(env1), {frame: { x:4 }, children: [{ frame: {}, children: [{frame: {}, children: []}] }] })
  end

# def structure(vertex)
#     {frame: vertex.frame, children: vertex.children.map { |i| tree(i) } }
#   end

########### 

  def test_env_binding
    env1 = Environment.new({ x:4, y:5 })
    env2 = Environment.new({ x:2 }, env1)
    assert_equal(env2.env_binding(:x), env2)
    assert_equal(env2.env_binding(:y), env1)
  end

  def test_printable?
    env = Environment.new({ x:4, y:5 })
    exp1 = [:define, :x, 1]
    exp2 = [:+, 1, 2]
    assert_equal(env.printable?(exp1), false)
    assert_equal(env.printable?(exp2), true)

  end


  # def printable?(x)
  #   (x[0] != :define) and (x[0] =! :set) and (x[0] =! :lambda)
  # end

########### Environmnet.value

  def test_value_variable
    env = Environment.new({ x:1 })
    exp = :x
    assert_equal(env.value(exp), 1)
  end

  def test_value_atom
    env = Environment.global_env
    exp = 1
    assert_equal(env.value(exp), 1)
  end

  def test_value_define
    env1 = Environment.new({ x:4, y:5 })
    exp = [:define, :x, 1]
    env1.value(exp)
    assert_equal(env1.frame[:x], 1)
  end

  def test_value_quote
    env1 = Environment.new({ x:4, y:5 })
    exp = [:quote, [1,2,3]]
    assert_equal(env1.value(exp), [1,2,3])
  end

  def test_value_set!
    env1 = Environment.new({ x:4, y:5 })
    env2 = Environment.new({ x:2 }, env1)
    exp1 = [:set!, :x, 1]
    exp2 = [:set!, :y, 1]
    env2.value(exp1); env2.value(exp2)
    assert_equal(env1.frame[:x], 4)
    assert_equal(env1.frame[:y], 1)
  end

  def test_value_begin
    env1 = Environment.global_env
    exp = [:begin, [:define, :x, 1], [:+, :x, 1]]
    assert_equal(env1.value(exp), 2)
  end

   def test_value_lambda
    env1 = Environment.global_env
    #env2 = Environment.new({ x:4, y:5 }, env1)
    exp = [:lambda, [:x, :y], [:+, :x, :y]]
    f = env1.value(exp)
    assert_equal(f.call(2,3),5)
   end

########### Parser

########### ReplActions


  


end
