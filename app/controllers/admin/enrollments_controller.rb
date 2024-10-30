class Admin::EnrollmentsController < Admin::BaseController
  def index
    @enrollments = Enrollment.group(:user_id).select("user_id, string_agg(enrollments.course_id::text, ',') as course_ids")
  end
end
