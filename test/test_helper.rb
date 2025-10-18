require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch
  filters.clear
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'

  groups.clear
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'

  track_files 'app/**/*.rb'

  # merge_timeout 3600
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'

Rails.application.eager_load!
module ActiveSupport
  ActiveSupport.on_load(:action_mailer) do
    Rails.application.reload_routes_unless_loaded
  end
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers
  end
end
