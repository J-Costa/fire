class StudentMailer < ApplicationMailer
  layout "mailer"
  default reply_to: nil

  def enrollment_email
    @student = params[:student]
    @courses = params[:courses]

    mail(to: email_address_with_name(@student.email, @student.name),
         subject: "Confirmação de Inscrição")
  end
end
