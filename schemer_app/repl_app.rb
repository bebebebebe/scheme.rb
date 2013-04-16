require 'sinatra'
require 'json'
require_relative 'label_interpreter'


repl = ReplActions.new

get '/' do
  redirect '/form'
end

get '/form' do
  erb :index
end

post '/form' do

  new_input = params[:message]
  begin
    value = repl.evaluate(new_input)

    print_status = repl.print_status(new_input)
    output = repl.printing
    treeData = repl.tree
 
    if print_status or (output[0..4] == ". . .")
      { error: false, value: output, tree: treeData, returnValue: output}.to_json
    else
      { error: false, value: output, tree: treeData, returnVaule: nil}.to_json
    end
  rescue
    { error: false, value: nil, returnValue: ". . . oops, syntax error"}.to_json
  end

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