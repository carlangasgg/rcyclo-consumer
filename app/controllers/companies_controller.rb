require 'httparty'
require 'json'

class CompaniesController < ApplicationController
  def sign_in

  end
  
  def login
    email = params[:email]
    password = params[:password]

    result_login_company = HTTParty.post('https://api-rcyclo.herokuapp.com/company_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@uid = result_login_company.headers["uid"]
    @@client = result_login_company.headers["client"]
    @@access_token = result_login_company.headers["access-token"]

    result_validate_login_company = HTTParty.get('https://api-rcyclo.herokuapp.com/company_auth/validate_token', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'index'
  end

  def index
    @company = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def new
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def show
  end

  def containers
    @containers = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/containers', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def request_container
    @waste_types = HTTParty.get('https://api-rcyclo.herokuapp.com/waste_types/all', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def request_container_choose_establishment
    @establishments = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/by_waste_type', :body => {:waste_type_id => params[:waste_type_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end
end
