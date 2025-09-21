class Admin::StudentsController < Admin::BaseController
  before_action :set_student, only: [:show, :edit, :update]

  def index
    @students = Student.order(created_at: :desc)
  end

  def show; end

  def edit; end

  def update
    if @student.update(student_params)
      redirect_to admin_student_path(@student), notice: "Aluno atualizado com sucesso."
    else
      render :edit
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :email, :phone, :contacted)
  end
end
