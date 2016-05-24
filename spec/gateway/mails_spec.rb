require 'spec_helper'

RSpec.describe Users do
  before :each do
    @token = '1234qwe'
    @base_uri = ENV['mailing_service']
  end
  context 'send_email' do
    it 'calls post /api/mails' do
      email = 'test@example.com'
      stub_request(:post, "#{@base_uri}/api/mails")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Mails.new(@token).send_welcome_email(email)
      expect(response.code).to eq 200
    end
  end
end
