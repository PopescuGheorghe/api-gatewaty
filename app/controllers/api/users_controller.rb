require_relative '../../gateway/users'
module Api
  class UsersController < ApplicationController
    before_action :set_user
    before_action do
      authenticate(request.headers['Authorization'])
    end

    before_action :clear_cache, only: [:create, :update, :delete]

    def me
      response = @user.me
      render json: response.parsed_response, status: response.code
    end

    def index
      response = fetch_users
      render json: response, status: 200
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

    def fetch_users
      users =  $redis.get("users")
      if users.nil?
        users  = @user.index.parsed_response.to_json
        $redis.set("users", users)
        # Expire the cache, every 1 hour
        $redis.expire("users",1.hour.to_i)
      end
      JSON.load users
    end

    def clear_cache
      $redis.del "users"
    end

    def set_user
      @user = Users.new(request.headers['Authorization'])
    end

    def user_params
      params.permit(:email, :password, :role)
    end
  end
end
