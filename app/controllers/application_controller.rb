class ApplicationController < ActionController::Base
  rescue_from  Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
    Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, Errno::ECONNREFUSED,
    with: :handle_net_errors

  respond_to :json
  include Authenticable

  protected

  def handle_net_errors(exception)
    render json: { success: false, errors: exception.message }
    return
  end

  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end
    private


    def setup_basic_api_documentation
      [:me, :index, :show, :create, :update, :destroy, :send_email].each do |api_action|
        swagger_api api_action do
          param :header, 'Authorization', :string, :optional, 'Authentication token'
        end
      end
    end
  end
end
