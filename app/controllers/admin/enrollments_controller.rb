class Admin::EnrollmentsController < Admin::BaseController
  def index
    @enrollments = Enrollment.all
  end
end