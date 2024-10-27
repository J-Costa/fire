class DashboardController < ApplicationController
  def welcome
    @featured_courses = Course.order(featured: :desc).limit(3)
  end
end
