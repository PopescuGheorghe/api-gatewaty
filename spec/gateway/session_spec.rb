require 'spec_helper'

RSpec.describe Session do
  before :each do
    @base_uri = ENV['user_service']
  end
  context 'login' do
    it 'calls user service post sessions' do
      stub_request(:post, "#{@base_uri}/api/sessions")
        .with(body: 'email=email%40example.com&password=password')
        .to_return(status: 200, body: 'success', headers: {})

      response = Session.new.login('email@example.com', 'password')
      expect(response.code).to eq 200
      expect(response.body).to eq 'success'
    end
  end
  context 'logout' do
    it 'calls user sessions destroy session' do
      token = '123qwe'
      stub_request(:delete, "#{@base_uri}/api/sessions/#{token}")
        .to_return(status: 200, body: 'success', headers: {})

      response = Session.new.logout(token)
      expect(response.code).to eq 200
      expect(response.body).to eq 'success'
    end
  end
end
