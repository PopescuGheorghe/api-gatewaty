require 'spec_helper'

RSpec.describe Users do
  before :each do
    @token = '1234qwe'
  end
  context 'me' do
    it 'calls get /api/users/me' do
      stub_request(:get, "#{ENV['user_service']}/api/users/me")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).me
      expect(response.code).to eq 200
    end
  end

  context 'index' do
    it 'calls get /api/users' do
      stub_request(:get, "#{ENV['user_service']}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).index
      expect(response.code).to eq 200
    end
  end

  context 'show' do
    it 'calls get /api/users/:id' do
      id = 1
      stub_request(:get, "#{ENV['user_service']}/api/users/#{id}")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).show(id)
      expect(response.code).to eq 200
    end
  end

  context 'create' do
    it 'calls post /api/users' do
      email = 'email@example.com'
      password = 'password'
      stub_request(:post, "#{ENV['user_service']}/api/users")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).create(email, password)
      expect(response.code).to eq 200
    end
  end

  context 'update' do
    it 'calls update /api/users/:id' do
      email = 'email@example.com'
      password = 'password'
      id = 1
      stub_request(:patch, "#{ENV['user_service']}/api/users/1")
        .with(body: 'email=email%40example.com&password=password',
              headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).update(id, email, password)
      expect(response.code).to eq 200
    end
  end

  context 'destroy' do
    it 'calls delete /api/users/:id' do
      id = 1
      stub_request(:delete, "#{ENV['user_service']}/api/users/#{id}")
        .with(headers: { 'Authorization' => '1234qwe' })
        .to_return(status: 200, body: '', headers: {})

      response = Users.new(@token).destroy(id)
      expect(response.code).to eq 200
    end
  end
end
