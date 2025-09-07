class NewEnrollmentMailer < ApplicationMailer
  layout "mailer"
  default reply_to: nil

  def notify_admins
    admins = Admin.where(email: params[:emails])

    mail(to: admins.map(&:email),
         subject: "Nova candidatura realizada na Krypton")
  end
end
