require 'httparty'
require 'json'

class EstablishmentsController < ApplicationController
  before_action :establishment_only, except: [:sign_in, :log_in]

  def sign_in
  end

  def log_in
    email = params[:email]
    password = params[:password]

    result_log_in_establishment = HTTParty.post('https://api-rcyclo.herokuapp.com/establishment_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@uid = result_log_in_establishment.headers["uid"]
    @@client = result_log_in_establishment.headers["client"]
    @@access_token = result_log_in_establishment.headers["access-token"]

    result_validate_log_in_establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishment_auth/validate_token', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'index'
  end

  def log_out
    HTTParty.delete('https://api-rcyclo.herokuapp.com/establishment_auth/sign_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to controller: 'welcome', action: 'index'
  end

  def index
    @establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
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
    @containers = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/containers', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def establishment_only
    if defined? @@access_token and defined? @@client and defined? @@uid
      establishment_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    else
      establishment_signed_in = false
    end

    unless establishment_signed_in
      redirect_to root_path
    end
  end
end
