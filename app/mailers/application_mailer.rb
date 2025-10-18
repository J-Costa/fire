class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('no-reply@kryptontreinamentos.com.br', 'Krypton Treinamentos'),
          reply_to: nil
  layout 'mailer'
end
