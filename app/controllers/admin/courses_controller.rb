class Admin::CoursesController < Admin::BaseController

  before_action :prepare_course, only: %i[new create]
  
  def index
    @courses = Course.all
  end

  def new; end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to admin_courses_path, notice: 'Curso cadastrado com sucesso'
    else
      redirect_to new_admin_course_path, alert: @course.errors.full_messages.to_sentence
    end
  end

  private 

  def prepare_course
    @course = Course.new
  end

  def course_params
    params.require(:course).permit(:name, :description, :featured)
  end
end
