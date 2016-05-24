require 'spec_helper'

describe Api::MailsController, type: :controller do
  before :each do
    @base_uri = ENV['mailing_service']
    @token = '1234qwe'
    request.headers['Authorization'] = @token
  end
  context 'send_email' do
    it 'calls post /send_email' do
      allow_any_instance_of(Api::MailsController).to receive(:authenticate).and_return true
      stub_request(:post, "#{@base_uri}/api/mails")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      post :send_email, email: 'test@example.com'
      expect(response.status).to eq 200
    end
  end
  context 'invalid request' do
    it 'renders unauthorized' do
      token = '1234'
      request.headers['Authorization'] = @token
      stub_request(:post, "#{ENV['authorization_service']}/authorize")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 401, body: '{"sucess": false}', headers: { 'Content-Type' => 'application/json' })

      expected_response = { 'sucess' => false, 'errors' => ['Unauthorized access'] }

      post :send_email, email: 'test@example.com'
      parsed_response = JSON.parse(response.body)

      expect(parsed_response).to eql expected_response
      expect(response.status).to eql 401
    end
  end
end
