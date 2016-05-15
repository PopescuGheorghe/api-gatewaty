class ApplicationController < ActionController::API
  respond_to :json
  include Authenticable
end
