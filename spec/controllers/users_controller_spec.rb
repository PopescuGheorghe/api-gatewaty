require 'spec_helper'

describe Api::UsersController, type: :controller do
  before :each do
    @base_uri = ENV['user_service']
    @token = '1234qwe'
    request.headers['Authorization'] = @token
    allow_any_instance_of(Api::UsersController).to receive(:authenticate).and_return true
  end

  context 'network timeout' do
    it 'raises error on timeout' do
      stub_request(:get, "#{@base_uri}/api/users/me")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_timeout

      get :me
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eql 500
      expect(parsed_response[:errors]).to eql 'execution expired'
    end

    it 'raises error on connection refused' do
      stub_request(:get, "#{@base_uri}/api/users/me")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_raise Errno::ECONNREFUSED

      get :me
      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eql 500
      expect(parsed_response[:errors]).to eql 'Connection refused - Exception from WebMock'
    end
  end

  context 'me' do
    it 'calls get /api/users/me' do
      stub_request(:get, "#{@base_uri}/api/users/me")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      get :me
      expect(response.status).to eq 200
    end
  end

  context 'index' do
    it 'calls get /api/users' do
      stub_request(:get, "#{@base_uri}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      get :index
      expect(response.status).to eq 200
    end

    it 'uses cached data if server is not available' do
      stub_request(:get, "#{@base_uri}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_timeout

      get :index
      expect(response.status).to eq 200
    end

    it 'returns error if server is down and cached is expired' do
      stub_request(:get, "#{@base_uri}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_timeout
      $redis.del("users")
      get :index
      expect(response.status).to eq 500
    end
  end

  context 'show' do
    it 'calls get /api/users/:id' do
      id = 1
      stub_request(:get, "#{@base_uri}/api/users/#{id}")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      get :show, id: id
      expect(response.status).to eq 200
    end
  end

  context 'create' do
    it 'calls post /api/users' do
      email = 'email@example.com'
      password = 'password'
      stub_request(:post, "#{@base_uri}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      post :create, email: email, password: password
      expect(response.status).to eq 200
    end
  end

  context 'update' do
    it 'calls update /api/users/:id' do
      email = 'email@example.com'
      password = 'password'
      id = 1
      stub_request(:patch, "#{@base_uri}/api/users/1")
        .with(body: 'email=email%40example.com&password=password&role=',
              headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      patch :update, id: id, email: email, password: password
      expect(response.status).to eq 200
    end
  end

  context 'destroy' do
    it 'calls delete /api/users/:id' do
      id = 1
      stub_request(:delete, "#{@base_uri}/api/users/#{id}")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      delete :destroy, id: id
      expect(response.status).to eq 200
    end
  end
end
