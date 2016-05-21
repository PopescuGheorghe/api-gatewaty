class Users < Gateway
  base_uri ENV['user_service']

  def initialize(token)
    self.class.headers 'Authorization' => token.to_s
  end

  def me
    self.class.get('/api/users/me')
  end

  def index
    self.class.get('/api/users')
  end

  def show(id)
    self.class.get("/api/users/#{id}")
  end

  def create(email, password)
    self.class.post(
      '/api/users',
      body: {
        email:    email,
        password: password
      }
    )
  end

  def update(id, email, password)
    self.class.patch(
      "/api/users/#{id}",
      body: {
        email:    email,
        password: password
      }
    )
  end

  def destroy(id)
    self.class.delete("/api/users/#{id}")
  end
end
