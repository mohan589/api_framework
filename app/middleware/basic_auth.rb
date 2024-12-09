require_relative "../services/whitelisted_routes"

class BasicAuth
  include WhitelistedRoutes

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    # Apply basic auth only to /resources path
    if WhitelistedRoutes.whitelisted?(request.path) || !request.path.match?(/^\/api-docs(\/.*)?$/)
      auth = Rack::Auth::Basic::Request.new(env)

      unless auth.provided? && auth.basic? && valid_credentials?(auth.credentials)
        return unauthorized_response
      end
    end

    @app.call(env)
  end

  private

  def valid_credentials?(credentials)
    username, password = credentials
    stripped_password = password.gsub(/[^0-9A-Za-z]/, '')
    generated_password =  PasswordGenerator.generate_password(username).gsub(/[^0-9A-Za-z]/, '')
    username == ENV['BASIC_AUTH_USER'] &&  stripped_password == generated_password # Replace with your logic or environment variables
  end

  def unauthorized_response
    [
      401,
      { 'Content-Type' => 'text/plain', 'WWW-Authenticate' => 'Basic realm="Restricted Area"' },
      ['Unauthorized']
    ]
  end
end
