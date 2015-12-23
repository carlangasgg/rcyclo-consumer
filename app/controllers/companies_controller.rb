require 'httparty'
require 'json'

class CompaniesController < ApplicationController
  before_action :company_only, except: [:sign_in, :log_in]

  def sign_in
  end

  def log_in
    email = params[:email]
    password = params[:password]

    result_log_in_company = HTTParty.post('https://api-rcyclo.herokuapp.com/company_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@uid = result_log_in_company.headers["uid"]
    @@client = result_log_in_company.headers["client"]
    @@access_token = result_log_in_company.headers["access-token"]

    result_validate_log_in_company = HTTParty.get('https://api-rcyclo.herokuapp.com/company_auth/validate_token', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'index'
  end

  def log_out
    HTTParty.delete('https://api-rcyclo.herokuapp.com/company_auth/sign_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@access_token = nil
    @@client = nil
    @@uid = nil

    redirect_to controller: 'welcome', action: 'index'
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
    @data = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/containers', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def request_container
    @data = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/waste_types_all', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def request_container_choose_establishment
    @data = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/establishments_by_waste_type', :body => {:waste_type_id => params[:waste_type_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def request_container_last_step
    HTTParty.get('https://api-rcyclo.herokuapp.com/companies/create_container_by_company_request', :body => {:current_company_id => params[:current_company_id], :establishment_id => params[:establishment_id], :waste_type_id => params[:waste_type_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'containers'
  end

  def update_state_container
    HTTParty.get('https://api-rcyclo.herokuapp.com/companies/update_state_container', :body => {:container_id => params[:container_id], :status_id => params[:status_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'containers'
  end

  def company_only
    company_signed_in = false

    if defined? @@access_token and defined? @@client and defined? @@uid and @@access_token and @@client and @@uid
      company_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    unless company_signed_in
      redirect_to root_path
    end
  end
end
