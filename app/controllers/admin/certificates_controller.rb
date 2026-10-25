class Admin::CertificatesController < Admin::BaseController
  before_action :prepare_certificate, only: %i[new create]
  before_action :load_enrollments, only: %i[new create edit update]
  before_action :set_certificate, only: %i[edit update]

  def index
    @certificates = Certificate.order(expires_at: :desc)
  end

  def new; end

  def create
    @certificate = Certificate.new(certificate_params)

    if @certificate.save
      redirect_to admin_certificates_path, notice: 'Certificado cadastrado com sucesso'
    else
      flash.now[:alert] = @certificate.errors.full_messages.to_sentence
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @certificate.update(certificate_params)
      redirect_to admin_certificates_path, notice: 'Certificado atualizado com sucesso'
    else
      flash.now[:alert] = @certificate.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_content
    end
  end

  private

  def prepare_certificate
    @certificate = Certificate.new(
      issued_at: Time.current,
      expires_at: 1.year.from_now,
      status: :active
    )
  end

  def load_enrollments
    @enrollments = Enrollment.includes(:user, :course).order(created_at: :desc)
  end

  def certificate_params
    params.require(:certificate).permit(:enrollment_id, :issued_at, :expires_at, :status)
  end

  def set_certificate
    @certificate = Certificate.find(params[:id])
  end
end