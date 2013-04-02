require 'sinatra'
require_relative './interpreter2'

inputs = []
repl = ReplActions.new


get '/' do
  redirect '/form'
end

get '/form' do
  @inputs = inputs
  erb :index
end

# post '/form' do
#   puts params[:message]
#   puts 'got ajax request'
#   { error: false, returnValue:"2" }.to_json
# end

post '/form' do
  puts "user typed: " + params[:message]  
  new_input = params[:message]
  value = repl.evaluate(new_input)
  value_scheme = repl.printing
  { error: false, returnValue: value_scheme}.to_json
end

# post '/form' do
#   new_input = params[:message]
#   begin
#     new_value = repl.evaluate(new_input)
#     new_value_scheme = repl.printing
#     inputs << ("> " + params[:message]) #echoes user input
#     inputs << ("=> " + new_value_scheme)
#   rescue 
#     inputs << ". . . oops, syntax error"
#   end
#   @inputs = inputs
#   @tree = GRAPH.to_json
#   erb :index
# end