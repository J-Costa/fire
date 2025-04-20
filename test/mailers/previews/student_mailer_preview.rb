# Preview all emails at http://localhost:3000/rails/mailers/student_mailer
class StudentMailerPreview < ActionMailer::Preview
  def enrollment_email
    student = Student.last
    courses = Course.all.sample(2)

    StudentMailer.with(student: student, courses: courses).enrollment_email
  end
end
