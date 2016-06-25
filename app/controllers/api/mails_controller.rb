require_relative '../../gateway/mails'
module Api
  class MailsController < ApplicationController
    before_action :set_mailing_service
    before_action do
      authenticate(request.headers['Authorization'])
    end

    swagger_controller :mails, "mailing service"

    swagger_api :send_email do
      summary "Send Welcome Email"
      param :form, :email, :string, :required, "Email"
      response :unauthorized
      response :bad_request
    end
    def send_email
      email = params[:email]
      response = @mailing_service.send_welcome_email(email)
      render json: response.parsed_response, status: response.code
    end

    private

    def set_mailing_service
      @mailing_service = Mails.new(request.headers['Authorization'])
    end
  end
end
