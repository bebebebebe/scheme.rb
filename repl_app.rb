require 'sinatra'
require 'securerandom'
require 'json'
require_relative './lib/repl'
require_relative './lib/environment'
require_relative './lib/parser'
require_relative './lib/tree'

enable :sessions

repl_db = {}

get '/' do
  session[:id] = SecureRandom.uuid
  repl_db[session[:id]] = Repl.new
  erb :index
end

post '/form' do
  if repl_db[session[:id]].nil?
    redirect '/'
  else
    new_input = params[:message]
    begin
      value = repl_db[session[:id]].evaluate(new_input)
      print_status = repl_db[session[:id]].print_status(new_input)
      output = repl_db[session[:id]].printing
      treeData = repl_db[session[:id]].tree   
      if print_status or (output[0..4] == ". . .")
        { error: false, value: output, tree: treeData, returnValue: output, session_ids: repl_db.keys.inspect }.to_json
      else
        { error: false, value: output, tree: treeData, returnVaule: nil}.to_json
      end
    rescue
      { error: false, value: nil, returnValue: ". . . oops, syntax error"}.to_json
    end
  end
end