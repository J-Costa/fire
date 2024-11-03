ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  primary_coverage :branch

  filters.clear
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/app/channels/"
  add_filter "/app/jobs/"
  add_filter "/app/mailers/"
  add_filter "app/views"

  groups.clear
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
end
Rails.application.eager_load!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
