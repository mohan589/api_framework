# app/middleware/authenticate_request.rb
class AuthenticateRequest
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if json_request?(request) && (request.path.start_with?('/resources/new') || !request.path.match?(/^\/api-docs(\/.*)?$/))
      authorization_header = request.env['HTTP_AUTHORIZATION']
      if authorization_header
        token = authorization_header.split(' ').last
        decoded_token = JsonWebToken.decode(token)

        if decoded_token
          # Add user information to the environment for further use
          env['current_user_id'] = decoded_token[:user_id]
          @app.call(env)
        else
          unauthorized_response
        end
      else
        unauthorized_response
      end
    else
      @app.call(env)
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    unauthorized_response
  end

  private

  def json_request?(request)
    request.content_type == 'application/json' || request.get_header('HTTP_ACCEPT')&.include?('application/json')
  end

  def unauthorized_response
    [
      401,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Unauthorized' }.to_json]
    ]
  end
end
