require_relative '../../gateway/session'
module Api
  class SessionsController < ApplicationController
    before_action :set_session

    def login
      user_email    = params[:email]
      user_password = params[:password]
      response = @session.login(user_email, user_password)
      render json: response.parsed_response, status: response.code
    end

    def logout
      token = params[:id]
      response = @session.logout(token)
      render json: response.parsed_response, status: response.code
    end

    private

    def set_session
      @session = Session.new
    end
  end
end
