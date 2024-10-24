class Admin::CoursesController < Admin::BaseController
  def index
    @courses = Course.all
  end

  def new; end
end
