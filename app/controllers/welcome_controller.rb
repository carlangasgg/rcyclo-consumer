class WelcomeController < ApplicationController
  def index
    @establishment_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/establishments/signed_in')
    @company_signed_in = HTTParty.get('https://api-rcyclo.herokuapp.com/companies/signed_in')
  end
end
