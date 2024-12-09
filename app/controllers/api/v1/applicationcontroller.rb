class API::V1::ApplicationController < ActionController::API
  private

  def current_user
    @current_user ||= User.find(request.env['current_user_id'])
  end
end
