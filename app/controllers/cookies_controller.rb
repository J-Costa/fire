class CookiesController < ApplicationController
  skip_before_action :track_ahoy_visit

  def accept
    cookies[:cookies_accepted] = 'true'
    ahoy
    redirect_back(fallback_location: root_path)
  end
end
