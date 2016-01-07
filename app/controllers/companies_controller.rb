require 'httparty'
require 'json'

class CompaniesController < ApplicationController
  before_action :active_company_only, except: [:sign_in, :log_in]

  def sign_in
  end

  def log_in
    email = params[:email]
    password = params[:password]

    result_log_in = HTTParty.post('https://api-rcyclo.herokuapp.com/company_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    case result_log_in.code
      when 200
        @@uid = result_log_in.headers["uid"]
        @@client = result_log_in.headers["client"]
        @@access_token = result_log_in.headers["access-token"]

        redirect_to :action => 'index'
      else
        flash[:wrong_credentials] = "Combinación de Email y Password Errónea"

        redirect_to action: 'sign_in'
    end

  end

  def log_out
    HTTParty.delete('https://api-rcyclo.herokuapp.com/company_auth/sign_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@access_token = nil
    @@client = nil
    @@uid = nil

    flash[:notice] = "Desconectado con éxito"
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
    @comp = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/edit', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

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
    HTTParty.get('https://api-rcyclo.herokuapp.com/companies/create_container_by_company_request', :body => {:establishment_id => params[:establishment_id], :waste_type_id => params[:waste_type_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    flash[:success] = "Contenedor solicitado. Espere confirmación"
    redirect_to action: 'containers'
  end

  def update_state_container
    HTTParty.get('https://api-rcyclo.herokuapp.com/companies/update_state_container', :body => {:container_id => params[:container_id], :status_id => params[:status_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to action: 'containers'
  end

  def configuration
    @company = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def drop_out
    HTTParty.get('https://api-rcyclo.herokuapp.com/companies/drop_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to controller: 'welcome', action: 'index'
  end

  def active_company_only
    if defined? @@access_token and defined? @@client and defined? @@uid
      company_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    if company_signed_in.nil?
      redirect_to root_path
    else
      if company_signed_in["active"] == false
        HTTParty.get('https://api-rcyclo.herokuapp.com/companies/return_to_rcyclo', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
      end
    end
  end

  def modify_data
    
    #result_modify_data = HTTParty.post('https://api-rcyclo.herokuapp.com/companies/modify_data', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    
    result_modify_data = HTTParty.post('https://api-rcyclo.herokuapp.com/companies/modify_data', :body => {"company" =>{:name => params[:name], :address => params[:address], :email=>params[:email]}}.to_json,:headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})


    #result_modify_data = HTTParty.post('https://api-rcyclo.herokuapp.com/companies/modify_data', :body => {:name => params[:name], :address => params[:address], :email=>params[:email]},:headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})


    case result_modify_data.code
      when 200
        @@uid = result_modify_data.headers["uid"]
        @@client = result_modify_data.headers["client"]
        @@access_token = result_modify_data.headers["access-token"]
        flash[:modify_data_success] = "Modificación ingresada. Debe esperar la validación del administrador para la actualización de sus datos."
        redirect_to :action => 'index'


      else
        flash[:modify_data_error] = "Ocurrió un problema con los datos ingresados"

        redirect_to action: 'edit'
    end


  end


end
