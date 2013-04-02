require 'sinatra'
require_relative '../interpreter'

inputs = []
repl = ReplActions.new


get '/' do
  redirect '/form'
end

get '/form' do
  @inputs = inputs
  erb :index
end

post '/form' do
  new_input = params[:message]
  begin
    new_value = repl.evaluate(new_input)
    new_value_scheme = repl.printing
    inputs << ("> " + params[:message]) #echoes user input
    inputs << ("=> " + new_value_scheme)
  rescue 
    inputs << ". . . oops, syntax error"
  end
  @inputs = inputs
  erb :index
end