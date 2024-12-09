# app/services/password_generator.rb
require 'openssl'
require 'base64'

class PasswordGenerator
  # Fetch the private key from the environment variable (or from a config)
  PRIVATE_KEY = ENV['PRIVATE_KEY'] || 'default_private_key'

  def self.generate_password(username)
    # Concatenate the username and private key
    combined_string = "#{username}:#{PRIVATE_KEY}"

    # Generate SHA-256 hash
    hashed = OpenSSL::Digest::SHA256.hexdigest(combined_string)

    # Optionally, encode the hash in Base64 for a human-readable password
    password = Base64.encode64(hashed).strip
    password
  end
end
