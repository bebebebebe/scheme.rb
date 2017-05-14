require 'sinatra'
require 'securerandom'
require 'json'
require_relative './lib/repl'
require_relative './lib/environment'
require_relative './lib/parser'
require_relative './lib/tree'

use Rack::Session::Pool

repl_db = {}

get '/' do
  session[:repl] = Repl.new
  erb :index
end

post '/form' do
  if session[:repl].nil?
    redirect '/'
  else
    new_input = params[:message]
    begin
      value = session[:repl].evaluate(new_input)
      print_status = session[:repl].print_status(new_input)
      output = session[:repl].printing
      treeData = session[:repl].tree
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