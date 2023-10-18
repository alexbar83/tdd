class OauthCallbacksController < ApplicationController
   def github
    render json: request.env['omniauth.auth']
  end
end
