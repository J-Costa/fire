class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern # disable to test on old browsers
  skip_before_action :track_ahoy_visit, if: :skip_ahoy?

  private

  def skip_ahoy?
    request.path == "/health_check" ||
    request.path.start_with?("rails/active_storage") ||
    request.path.include?("manifest.json") ||
    params[:skip_ahoy].present?
  end
end
