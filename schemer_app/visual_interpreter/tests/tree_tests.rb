require_relative '../tree'
require 'minitest/autorun'

class InterpreterTest < MiniTest::Unit::TestCase




  def test_schemify
    array = [:define, :square, [:lambda, [:x], [:*, :x, :x]]]
    assert_equal(Tree.schemify(array), "(define square (lambda (x) (* x x)))")
  end



  # def self.schemify(array)
  #   string = array.to_s
  #   string.gsub("[", "(").gsub("]",")").gsub(":", "").gsub(",","")
  # end




########### Tree module
  # def test_structure
  #   env1 = Environment.new({ x:4 })
  #   env2 = Environment.new({}, env1)
  #   env3 = Environment.new({}, env2)
  #   assert_equal(Tree.structure(env1), {frame: { x:4 }, children: [{ frame: {}, children: [{frame: {}, children: []}] }] })
  # end

# def structure(vertex)
#     {frame: vertex.frame, children: vertex.children.map { |i| tree(i) } }
#   end

########### 



end