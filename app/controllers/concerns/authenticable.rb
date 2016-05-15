module Authenticable
  def authenticate(token)
    validate(token) || render_unauthorized
  end

  def validate(token)
    response = Authorization.new(token).authorize
    parse_response(response)
  end

  def parse_response(response)
    response.parsed_response['success'] || response.parsed_response[:success]
  end

  def render_unauthorized
    headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { sucess: false, errors: ['Unauthorized access'] }, status: 401
  end
end
