class Admin::EnrollmentsController < Admin::BaseController
  def index
    @enrollments = Enrollment
      .joins(:user)
      .group(:user_id, "users.created_at, users.contacted")
      .select("user_id, string_agg(enrollments.course_id::text, ',') as course_ids, contacted")
      .order("users.created_at DESC, users.contacted ASC")
  end
end
