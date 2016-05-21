class Authorization < Gateway
  base_uri ENV['authorization_service']

  def initialize(token)
    self.class.headers 'Authorization' => token.to_s
  end

  def authorize
    self.class.post('/authorize')
  end
end
