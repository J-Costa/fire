ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

if File.basename($PROGRAM_NAME) == "rails" && ARGV[0] =~ /^test/ || ENV["RAILS ENV"] == "test"
  require_relative "../test/test_helper"
end
