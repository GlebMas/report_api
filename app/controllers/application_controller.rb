class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end

  private

  def authenticate
    authenticate_user!

    if current_user.token.nil? || current_user.token_expired?
      data = {
        "user": "test.api",
        "password": "5DRX-AF-gc4",
        "client_id": "Test",
        "client_secret": "xIpXeyMID9WC55en6Nuv0HOO5GNncHjeYW0t5yI5wpPIqEHV"
      }
      platform_161 = Api::Platform161.new(data)

      current_user.token = platform_161.access_tokens.parsed_response["token"]
      current_user.token_created = Time.now
      current_user.save
    end
  end

end
