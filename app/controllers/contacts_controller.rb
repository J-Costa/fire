class ContactsController < ApplicationController
  before_action :prepare_student, only: [:new]

  def new; end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to root_path, notice: "Salvamos seu contato, assim que possível entraremos em contato."
    else
      flash.now[:alert] = @student.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def prepare_student
    @student = Student.new
  end

  def student_params
    params.require(:contact).permit(:name, :email, :phone)
  end
end