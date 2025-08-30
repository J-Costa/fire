class Admin::EnrollmentsController < Admin::BaseController
  def index
    @enrollments = Enrollment
      .joins(:user)
      .group(:user_id, "users.created_at")
      .select("user_id, string_agg(enrollments.course_id::text, ',') as course_ids")
      .order("users.created_at DESC")
  end
end
