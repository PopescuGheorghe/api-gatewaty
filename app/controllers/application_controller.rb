class ApplicationController < ActionController::Base
  respond_to :json
  include Authenticable
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
