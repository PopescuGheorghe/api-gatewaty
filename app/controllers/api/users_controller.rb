require_relative '../../gateway/users'
module Api
  class UsersController < ApplicationController
    before_action :set_user
    before_action do
      authenticate(request.headers['Authorization'])
    end

    def me
      response = @user.me
      render json: response.parsed_response, status: response.code
    end

    def index
      response = @user.index
      render json: response.parsed_response, status: response.code
    end

    def show
      id = params[:id]
      response = @user.show(id)
      render json: response.parsed_response, status: response.code
    end

    def create
      user_email    = user_params[:email]
      user_password = user_params[:password]
      user_role     = user_params[:role]
      response = @user.create(user_email, user_password, user_role)
      render json: response.parsed_response, status: response.code
    end

    def update
      id = params[:id]
      user_email    = params[:email]
      user_password = params[:password]
      user_role     = user_params[:role]
      response = @user.update(id, user_email, user_password, user_role)
      render json: response.parsed_response, status: response.code
    end

    def destroy
      id = params[:id]
      response = @user.destroy(id)
      render json: response.parsed_response, status: response.code
    end

    private

    def set_user
      @user = Users.new(request.headers['Authorization'])
    end

    def user_params
      params.permit(:email, :password, :role)
    end
  end
end
