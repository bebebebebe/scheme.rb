require_relative '../tree'
require_relative '../environment'
require 'minitest/autorun'

class InterpreterTest < MiniTest::Unit::TestCase

  def test_structure
    env1 = Environment.new({ x:4 })
    env2 = Environment.new({}, env1)
    env3 = Environment.new({}, env2)
    assert_equal(Tree.structure(env1), {frame: "{x: 4}", children: [{ frame: "{}", children: [{frame: "{}", children: []}] }] })
  end

  def test_process_frame
    frame = { :x => 5, :f => Proc.new{} }
    label = { :x => [:+, 2, 3], :f => [:lambda, [:x], [:*, :x, :x]] }
    assert_equal(Tree.process_frame(frame, label), "{x: 5, f: (lambda (x) (* x x))}")
  end

  def test_schemify
    array = [:define, :square, [:lambda, [:x], [:*, :x, :x]]]
    assert_equal(Tree.schemify(array), "(define square (lambda (x) (* x x)))")
  end

end