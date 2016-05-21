class Session < Gateway
  base_uri ENV['mailing_service']

  def send_welcome_email
    self.class.post("/api/mails")
  end
end
