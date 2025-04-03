class ContactsController < ApplicationController
  before_action :prepare_contact, only: [:new, :create]

  def new
    @email = params["email"]
  end

  def create
    Student.transaction do
      @student = Student.new(student_params)
      if course_params.blank?
        flash.now[:alert] = "Selecione ao menos um curso"
        return render :new, status: :unprocessable_entity
      end

      if @student.save
        course_params.each do |course_id|
          Enrollment.create!(course_id: course_id, user_id: @student.reload.id)
        end
        redirect_to root_path, notice: "Salvamos seu contato, assim que possível entraremos em contato."
      else
        flash.now[:alert] = @student.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def prepare_contact
    @student = Student.new
    @courses = Course.order(featured: :desc).limit(4)
  end

  def student_params
    params.require(:contact).permit(:name, :email, :phone)
  end

  def course_params
    params.require(:enrollments).permit(course_ids: [])[:course_ids].compact_blank
  end
end
