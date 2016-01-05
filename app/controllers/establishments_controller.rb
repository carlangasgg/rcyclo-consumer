require 'httparty'
require 'json'

class EstablishmentsController < ApplicationController
  before_action :establishment_only, except: [:sign_in, :log_in]

  def sign_in
  end

  def log_in
    email = params[:email]
    password = params[:password]

    result_log_in = HTTParty.post('https://api-rcyclo.herokuapp.com/establishment_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    case result_log_in.code
      when 200
        @@uid = result_log_in.headers["uid"]
        @@client = result_log_in.headers["client"]
        @@access_token = result_log_in.headers["access-token"]

        redirect_to :action => 'index'
      else
        flash[:wrong_credentials] = "Mala combinación de email y password."

        redirect_to :action => 'sign_in'
      end
  end

  def log_out
    HTTParty.delete('https://api-rcyclo.herokuapp.com/establishment_auth/sign_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    @@access_token = nil
    @@client = nil
    @@uid = nil

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
    @data = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/containers', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def accept_container_request
    HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/accept_container_request', :body => {:container_id => params[:container_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to :action => 'containers'
  end

  def establishment_only
    establishment_signed_in = false

    if defined? @@access_token and defined? @@client and defined? @@uid and @@access_token and @@client and @@uid
      establishment_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    unless establishment_signed_in
      redirect_to root_path
    end
  end

  def update_state_container
    HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/update_state_container', :body => {:container_id => params[:container_id], :status_id => params[:status_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to action: 'containers'
  end

  def delete_container

    result_delete_container = HTTParty.post('https://api-rcyclo.herokuapp.com/establishments/delete_container', :body => {:id_container => params[:id_container]}.to_json,:headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    flash[:container_erased] = "Contenedor eliminado"
    #CompanyMailer.container_erased_explanation(company, current_establishment).deliver_later
    redirect_to :action => 'index'

  end

end
