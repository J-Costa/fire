# Patch for devise and rails 8 lazy routes load. ref: https://alvincrespo.hashnode.dev/rails-8s-lazy-route-loading-devise

require 'devise'
Devise # make sure it's already loaded

module Devise
  def self.mappings
    Rails.application.try(:reload_routes_unless_loaded)
    @@mappings
  end
end
