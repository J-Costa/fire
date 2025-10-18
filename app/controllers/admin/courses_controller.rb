class Admin::CoursesController < Admin::BaseController
  before_action :prepare_course, only: %i[new create]
  before_action :set_course, only: %i[edit update]

  def index
    @courses = Course.order(featured: :desc)
  end

  def new; end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to admin_courses_path, notice: 'Curso cadastrado com sucesso'
    else
      flash.now[:alert] = @course.errors.full_messages.to_sentence
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @course.update(course_params)
      check_marketing_image_removal

      redirect_to admin_courses_path, notice: 'Curso atualizado com sucesso'
    else
      flash.now[:alert] = @course.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_content
    end
  end

  private

  def prepare_course
    @course = Course.new
  end

  def course_params
    params.require(:course).permit(:name, :description, :details, :marketing, :featured)
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def check_marketing_image_removal
    return unless params[:remove_marketing] == '1'
    return unless @course.marketing.attached?

    @course.marketing.purge
  end
end
