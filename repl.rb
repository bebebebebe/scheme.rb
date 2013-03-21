require './interpreter.rb'

repl = Repl.new

puts; puts "     type 'no more scheming' to exit the REPL"

loop do
  repl.prompt
  repl.read; break if (repl.input == "no more scheming")
  repl.evaluate
  repl.printing
 end