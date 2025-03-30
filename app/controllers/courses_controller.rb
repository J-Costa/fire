class CoursesController < ApplicationController
  def index
    @courses = Course.order(:featured)
  end

  def show
    @course = Course.find(params[:id])
    @featured_courses = Course.where.not(id: @course.id).order(featured: :desc).limit(3)
  end
end
