class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    resp = Faraday.get("https://foursquare.com/oauth2/access_token") do |req|
      req.params['client_id'] = ENV['FOURSQUARE_CLIENT_ID']
      req.params['client_secret'] = ENV['FOURSQUARE_SECRET']
      req.params['grant_type'] = 'authorization_code'
      req.params['redirect_uri'] = 'http://localhost:3000/auth'
      req.params['code'] = params[:code]
    end
    #resp is a bunch of data including method, body, url...
    #we parse resp.body. body = {access_token: YOUR TOKEN}
    body = JSON.parse(resp.body)
    #Set session[:token] to body["access_token"]
    session[:token] = body["access_token"]
    redirect_to root_path
  end
end
