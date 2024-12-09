# lib/tasks/password_generator.rake
namespace :generate do
  desc "Generate a password using a username (private key is from the code)"
  task :token, [:username] => :environment do |t, args|
    if args[:username].blank?
      puts "Please provide a username."
      next
    end

    password = PasswordGenerator.generate_password(args[:username])
    puts "Generated Password: #{password}"
  end
end
