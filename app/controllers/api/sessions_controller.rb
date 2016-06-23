require_relative '../../gateway/session'
module Api
  class SessionsController < ApplicationController
    before_action :set_session

    swagger_controller :sessions, "Sessions"

    swagger_api :login do
      summary "Login"
      param :form, :email, :string, :required, "Email"
      param :form, :password, :string, :required, "Password"
      response :unauthorized
      response :bad_request
    end

    swagger_api :logout do
      summary "Logout"
      param :path, :id, :required, "Token"
      response :unauthorized
      response :bad_request
    end

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
