require './interpreter.rb'

repl = Repl.new

puts; puts; puts "     type 'no more scheming' to exit the REPL"; puts

loop do
  repl.prompt
  repl.read; break if (repl.input == "no more scheming")
  begin
    repl.evaluate
    repl.printing
  rescue
    puts ". . . oops, syntax error"; puts
  end
 end

