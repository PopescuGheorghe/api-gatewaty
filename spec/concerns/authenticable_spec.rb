require 'spec_helper'

class Authentication
  include Authenticable
end

describe Authenticable, type: :controller do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe 'unauthorized authentication' do
    before do
      @token = '123qwe'
      allow(authentication).to receive(:validate).with(@token).and_return false
      allow(authentication).to receive(:render_unauthorized).and_return 'Unauthorized access'
    end

    it 'renders a json error message' do
      json_response = authentication.authenticate(@token)
      expect(json_response).to eql 'Unauthorized access'
    end
  end

  describe 'authorized authentication' do
    before do
      @token = '123qwe'
      allow(authentication).to receive(:validate).with(@token).and_return true
    end
    it 'renders successful response' do
      json_response = authentication.authenticate(@token)
      expect(json_response).to eql true
    end
  end
  describe 'parse_response' do
    it 'parsed the response correctly' do
      status = {}
      status['success'] = true
      response = double('response')
      allow(response).to receive(:parsed_response).and_return status
      expect(authentication.parse_response(response)).to eql true
    end
  end
  describe 'validate' do
    it 'validates token' do
      token = '124qwe'
      stub_request(:post, "http://localhost:3002/authorize").
         with(:headers => {'Authorization'=>'124qwe'}).
         to_return(:status => 200, :body => { success: true }.to_json, :headers => {})
      response = authentication.validate(token)
      expect(response).to eql "success"
    end
  end
end
