class ApplicationController < ActionController::API
  rescue_from  Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
    Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
    Net::ProtocolError, Errno::ECONNREFUSED,
    with: :handle_net_errors

  respond_to :json
  include Authenticable

  protected

  def handle_net_errors(exception)
    render json: { success: false, errors: exception.message }, status: 500
    return
  end
end
