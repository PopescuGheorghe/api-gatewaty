class Mails < Gateway
  base_uri ENV['mailing_service']

  def initialize(token)
    self.class.headers 'Authorization' => token.to_s
  end

  def send_welcome_email(email)
    self.class.post('/api/mails',
      body: {
        email: email
      }
    )
  end
end
