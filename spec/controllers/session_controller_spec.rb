require 'spec_helper'

describe Api::SessionsController, type: :controller do
  before :each do
    @base_uri = ENV['user_service']
  end

  context 'login' do
    it 'calls session login' do
      stub_request(:post, "#{@base_uri}/api/sessions")
        .with(body: 'email=email%40example.com&password=password')
        .to_return(status: 200, body: 'success', headers: {})
      credentials = { email: 'email@example.com', password: 'password' }

      post :login, credentials
      expect(response.status).to eql 200
    end

    context 'logout' do
      it 'calls user sessions destroy session' do
        token = '123qwe'
        stub_request(:delete, "#{@base_uri}/api/sessions/#{token}")
          .to_return(status: 200, body: 'success', headers: {})

        delete :logout, id: token
        expect(response.status).to eq 200
      end
    end
  end
end
