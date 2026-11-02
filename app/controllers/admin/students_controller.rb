class Admin::StudentsController < Admin::BaseController
  before_action :prepare_student, only: [:new, :create]
  before_action :set_student, only: [:show, :edit, :update]

  def index
    @students = Student.order(created_at: :desc)
  end

  def show; end

  def new; end

  def create
    @student = Student.new(student_params)
    @student.skip_confirmation!

    if @student.save
      redirect_to admin_students_path, notice: 'Aluno cadastrado com sucesso.'
    else
      flash.now.alert = @student.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @student.update(student_params)
      redirect_to admin_students_path, notice: 'Aluno atualizado com sucesso.'
    else
      flash.now.alert = @student.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def prepare_student
    @student = Student.new
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    permitted = params.require(:student).permit(:name, :email, :phone, :document, :contacted, :enrolled)
    permitted[:phone] = permitted[:phone].to_s.gsub(/\D/, '') if permitted.key?(:phone)
    permitted[:document] = permitted[:document].to_s.gsub(/\D/, '') if permitted.key?(:document)
    permitted
  end
end
