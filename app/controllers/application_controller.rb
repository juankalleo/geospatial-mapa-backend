class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_standard_error(exception)
    Rails.logger.error "Error: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    
    render json: { 
      error: 'Internal server error',
      message: Rails.env.development? ? exception.message : nil
    }, status: :internal_server_error
  end
end
