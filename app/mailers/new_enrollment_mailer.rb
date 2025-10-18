class NewEnrollmentMailer < ApplicationMailer
  layout 'mailer'
  default reply_to: nil

  def notify_admins
    admin_emails = ENV['ADMIN_EMAILS_TO_NOTIFY'].split(';')
    admins = Admin.where(email: admin_emails)

    mail(to: admins.pluck(:email),
         subject: 'Nova candidatura no site.')
  end
end
