require_relative '../../gateway/users'
module Api
  class UsersController < ApplicationController
    before_action :set_user
    before_action do
      authenticate(request.headers['Authorization'])
    end

    swagger_controller :users, "User Management"

    swagger_api :index do
      summary "Fetches all User items"
      notes "This lists all the active users"
      response :ok
      response :unauthorized
      response :not_acceptable, "The request you made is not acceptable"
    end

    swagger_api :me do
      summary "Fetches current user"
      response :ok, "Success", :User
      response :unauthorized
      response :not_found
    end

    swagger_api :show do
      summary "Fetches a single User item"
      param :path, :id, :required, "User ID"
      response :ok, "Success", :User
      response :unauthorized
      response :not_acceptable
      response :not_found
    end

    swagger_api :create do
      summary "Creates a new User"
      param :form, :email, :string, :optional, "Email"
      param :form, :password, :string, :optional, "password"
      param_list :form, :role, :string, :optional, "Role", [ "admin", "normal" ]
      response :ok
      response :unauthorized
      response :not_acceptable
    end

    swagger_api :update do
      summary "Updates an existing User"
      param :path, :id, :integer, :required, "User Id"
      param :form, :email, :string, :optional, "Email"
      param :form, :password, :string, :optional, "password"
      param_list :form, :role, :string, :optional, "Role", [ "admin", "superadmin", "user" ]
      response :ok
      response :unauthorized
      response :not_found
      response :not_acceptable
    end

    swagger_api :destroy do
      summary "Deletes an existing User item"
      param :path, :id, :integer, :required, "User Id"
      response :unauthorized
      response :not_found
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
