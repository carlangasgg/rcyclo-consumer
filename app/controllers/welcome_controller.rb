require 'httparty'
require 'json'

class WelcomeController < ApplicationController
  def index
  end
  
  def login_company
    @result_login_company = HTTParty.post('https://api-rcyclo.herokuapp.com/company_auth/sign_in', :body => {:email => params[:email], :password => params[:password]}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    @uid = @result_login_company.headers["uid"]
    @client = @result_login_company.headers["client"]
    @access_token = @result_login_company.headers["access-token"]
    
    @result_validate_login_company = HTTParty.get('https://api-rcyclo.herokuapp.com/company_auth/validate_token', :headers => {"access-token" => @access_token, "client" => @client, "uid" => @uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    redirect_to :controller => 'companies', :action => 'index'
  end
  
  def login_establishment
    @result_login_establishment = HTTParty.post('https://api-rcyclo.herokuapp.com/establishment_auth/sign_in', :body => {:email => params[:email], :password => params[:password]}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    @uid = @result_login_establishment.headers["uid"]
    @client = @result_login_establishment.headers["client"]
    @access_token = @result_login_establishment.headers["access-token"]
    
    @result_validate_login_establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/company_auth/validate_token', :headers => {"access-token" => @access_token, "client" => @client, "uid" => @uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    redirect_to :controller => 'establishments', :action => 'index'
  end
end