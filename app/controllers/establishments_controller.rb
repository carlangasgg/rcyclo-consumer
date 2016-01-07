require 'httparty'
require 'json'

class EstablishmentsController < ApplicationController
  before_action :not_erased_establishment_only, except: [:sign_in, :log_in, :sign_up, :register]
  before_action :active_establishment_only, except: [:sign_in, :log_in, :sign_up, :register]
  

  def active_establishment_only
    if defined? @@access_token and defined? @@client and defined? @@uid
      establishment_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    if establishment_signed_in.nil? or establishment_signed_in["active"] == false
      redirect_to root_path
    end
  end

  def sign_in
  end

  def sign_up
  end

  def register
    result_register = HTTParty.post('https://api-rcyclo.herokuapp.com/establishments/new', :body => {:name => params[:name], :address => params[:address], :email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation]}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    flash[:establishment_validate] = "Solicitud enviada. Espere la validación de administración vía email."
    redirect_to controller: 'welcome', action: 'index'
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

    flash[:est_notice] = "Desconectado con éxito"
    redirect_to controller: 'welcome', action: 'index'
  end

  def index
    @establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    @data = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/containers', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end

  def new
  end

  def create
  end

  def update
  end

  def edit_data
    establishment_edit = HTTParty.post('https://api-rcyclo.herokuapp.com/establishments/update', :body => {:name => params[:name], :email => params[:email], :address => params[:address]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    case establishment_edit.code
      when 200
        flash[:updated_data_succes] = "Los datos fueron actualizados."
      else
        flash[:updated_data_failure] = "Hubo un error en la actualización de sus datos."
      end

      redirect_to :action => 'configuration'
  end

  def edit_password
    establishment_edit_password = HTTParty.put('https://api-rcyclo.herokuapp.com/establishment_auth/', :body => {:password => params[:password], :password_confirmation => params[:password_confirmation]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    case establishment_edit_password.code
      when 200
        flash[:updated_pass_succes] = "La contraseña fue actualizada."
      else
        flash[:updated_pass_failure] = "Hubo un error en la actualización de su contraseña."
      end

      redirect_to :action => 'configuration'
  end

  def drop_out
    HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/drop_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    flash[:dropout] = "Haz sido dado de baja. Para reactivar tu cuenta, inicia sesión."
    redirect_to controller: 'welcome', action: 'index'
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

    flash[:container_succes] = "Contenedor validado exitosamente."
    redirect_to :action => 'containers'
  end

  def configuration
    @establishment = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
  end



  def update_state_container
    HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/update_state_container', :body => {:container_id => params[:container_id], :status_id => params[:status_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    redirect_to action: 'containers'
  end

  def delete_container
    result_delete_container = HTTParty.post('https://api-rcyclo.herokuapp.com/establishments/delete_container', :body => {:id_container => params[:id_container]}.to_json,:headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    flash[:container_erased] = "Contenedor eliminado."
    redirect_to :action => 'index'
  end

  def not_erased_establishment_only
    if defined? @@access_token and defined? @@client and defined? @@uid
      establishment_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
    end

    if establishment_signed_in.nil?
      redirect_to root_path
    else
      if establishment_signed_in["erased"] == false
        HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/return_to_rcyclo', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
      end
    end
  end
end
