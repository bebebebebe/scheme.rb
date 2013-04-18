require_relative '../environment'
require 'minitest/autorun'

class InterpreterTest < MiniTest::Unit::TestCase

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


########### value

  def test_evaluate_variable
    env = Environment.new({ x:1 })
    exp = :x
    assert_equal(env.evaluate(exp), 1)
  end

  def test_evaluate_atom
    env = Environment.global_env
    exp = 1
    assert_equal(env.evaluate(exp), 1)
  end

  def test_evaluate_define
    env1 = Environment.new({ x:4, y:5 })
    exp = [:define, :x, 1]
    env1.evaluate(exp)
    assert_equal(env1.frame[:x], 1)
  end

  def test_evaluate_quote
    env1 = Environment.new({ x:4, y:5 })
    exp = [:quote, [1,2,3]]
    assert_equal(env1.evaluate(exp), [1,2,3])
  end

  def test_evaluate_set!
    env1 = Environment.new({ x:4, y:5 })
    env2 = Environment.new({ x:2 }, env1)
    exp1 = [:set!, :x, 1]
    exp2 = [:set!, :y, 1]
    env2.evaluate(exp1); env2.evaluate(exp2)
    assert_equal(env1.frame[:x], 4)
    assert_equal(env1.frame[:y], 1)
  end

  def test_value_set_returns_error_if_var_underined
    env1 = Environment.new({ x:4 })
    exp1 = [:set!, :y, 1]
    assert_equal(env1.evaluate(exp1), ". . . oops, y can't be set as it isn't defined")
  end

  def test_evaluate_begin
    env1 = Environment.global_env
    exp = [:begin, [:define, :x, 1], [:+, :x, 1]]
    assert_equal(env1.evaluate(exp), 2)
  end

  def test_evaluate_lambda
    env1 = Environment.global_env
    exp = [:lambda, [:x, :y], [:+, :x, :y]]
    f = env1.evaluate(exp)
    assert_equal(f.call(2,3),5)
  end

end
