class AdminsController < ApplicationController
	before_action :admin_only, except: [:sign_in, :log_in]

	def sign_in
	end

	def log_in
		email = params[:email]
		password = params[:password]

		result_log_in = HTTParty.post('https://api-rcyclo.herokuapp.com/admin_auth/sign_in', :body => {:email => email, :password => password}.to_json, :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

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
		HTTParty.delete('https://api-rcyclo.herokuapp.com/admin_auth/sign_out', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

		@@access_token = nil
		@@client = nil
		@@uid = nil

		redirect_to controller: 'welcome', action: 'index'
	end

	def admin_only
	    admin_signed_in = false

	    if defined? @@access_token and defined? @@client and defined? @@uid and @@access_token and @@client and @@uid
	      admin_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/admins/signed_in', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
	    end

	    unless admin_signed_in
	      redirect_to root_path
	    end
	 end



	def index
		@admin = HTTParty.get('https://api-rcyclo.herokuapp.com/admins/index', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})
	end

	def new_company
		@comps = HTTParty.get('https://api-rcyclo.herokuapp.com/admins/new_company', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

	end

	def accept_company
		HTTParty.get('https://api-rcyclo.herokuapp.com/admins/accept_company', :body => {:comp_id => params[:comp_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    	redirect_to action: 'new_company'
	end

	def new_establishment
		@ests = HTTParty.get('https://api-rcyclo.herokuapp.com/admins/new_establishment', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

	end

	def accept_establishment
		HTTParty.get('https://api-rcyclo.herokuapp.com/admins/accept_establishment', :body => {:est_id => params[:est_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    	redirect_to action: 'new_establishment'
	end

	def change_request
		@change = HTTParty.get('https://api-rcyclo.herokuapp.com/admins/change_request', :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

	end

	def accept_change_request
		HTTParty.get('https://api-rcyclo.herokuapp.com/admins/accept_change_request', :body => {:change_id => params[:change_id]}.to_json, :headers => {"access-token" => @@access_token, "client" => @@client, "uid" => @@uid, 'Content-Type' => 'application/json', 'Accept' => 'application/json'})

    	redirect_to action: 'change_request'
	end

end
