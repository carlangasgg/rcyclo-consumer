require 'httparty'
require 'json'

class EstablishmentsController < ApplicationController
  def login
    email = params[:email]
    password = params[:password]

    result_login_establishment = HTTParty.post('https://api-rcyclo.herokuapp.com/establishment_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@uid = result_login_establishment.headers["uid"]
    @@client = result_login_establishment.headers["client"]
    @@access_token = result_login_establishment.headers["access-token"]

    result_validate_login_establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishment_auth/validate_token', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'index'
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

  def index
    @establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def show
  end
end
