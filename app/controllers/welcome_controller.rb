require 'httparty'
require 'json'

class WelcomeController < ApplicationController
  def index
  end
  
  def login_company

  end
  
  def login_establishment
    #email = params[:email]
    #password = params[:password]
    
    #result_login_establishment = HTTParty.post('https://api-rcyclo.herokuapp.com/establishment_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    #uid = result_login_establishment.headers["uid"]
    #client = result_login_establishment.headers["client"]
    #access_token = result_login_establishment.headers["access-token"]
    
    #result_validate_login_establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishment_auth/validate_token', :headers => {"access-token" => access_token, "client" => client, "uid" => uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    #if CurrentUser.find_by(:email => email) # De alguna forma debemos soportar que el usuario este logeado en el celular y en su PC, es decir, no podemos simplemente buscarlo por el email (considerar el uso de client)
      #CurrentUser.last.update_attributes(:email => email,:uid => uid, :client => client, :access_token => access_token)
    #else
      #CurrentUser.create(:email => email, :uid => uid, :client => client, :access_token => access_token)
    #end
    
    #redirect_to :controller => 'establishments', :action => 'index', :email => email
  end
end