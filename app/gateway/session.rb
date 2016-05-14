class Session < Gateway
  def login(email, password)
    self.class.post(
      '/api/sessions',
      body: {
        email:    email,
        password: password
      }
    )
  end

  def logout(token)
    self.class.delete("/api/sessions/#{token}")
  end
end
