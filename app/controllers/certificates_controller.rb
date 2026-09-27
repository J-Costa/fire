class CertificatesController < ApplicationController
  rate_limit to: ENV.fetch('CERTIFICATE_RATE_LIMIT', 30).to_i,
             within: ENV.fetch('CERTIFICATE_RATE_PERIOD', 60).to_i.seconds,
             by: -> { request.remote_ip },
             with: -> { rate_limit_exceeded },
             name: 'certificate_validation'
  before_action :find_certificate, only: :show

  def new
  end

  def create
    @certificate = Certificate.find_by(code: normalized_code)

    if @certificate
      render :show
    else
      flash.now[:alert] = 'Certificado não encontrado.'
      render :new, status: :not_found
    end
  end

  def show
    return if @certificate

    render :show, status: :not_found
  end

  private

  def find_certificate
    @certificate = Certificate.find_by(code: normalized_code)
  end

  def normalized_code
    params[:code].to_s.strip.upcase.presence || params.dig(:certificate, :code).to_s.strip.upcase
  end

  def rate_limit_exceeded
    response.set_header('Retry-After', ENV.fetch('CERTIFICATE_RATE_PERIOD', 60).to_i.to_s)
    render plain: 'Muitas tentativas. Tente novamente em alguns instantes.', status: :too_many_requests
  end
end
