module ApplicationHelper
  def certificate_public_url(certificate)
    certificate_url(certificate.code)
  end

  def certificate_qr_svg(certificate)
    qr_code = RQRCode::QRCode.new(certificate_public_url(certificate))

    qr_code.as_svg(module_size: 4, standalone: true).html_safe
  end

  def certificate_whatsapp_url(certificate)
    phone = certificate.user.phone.to_s.gsub(/\D/, '')
    return if phone.length < 10 || phone.length > 11

    message = "Olá #{certificate.user.name}, seu certificado está disponível para validação: #{certificate_public_url(certificate)}"
    "https://wa.me/55#{phone}?text=#{ERB::Util.url_encode(message)}"
  end
end
