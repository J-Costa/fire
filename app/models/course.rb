class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
  has_one_attached :marketing

  validates :name, :description, :featured, presence: true
  validates :name, uniqueness: true
  validates :description, length: { minimum: 10 }
  validates :featured, numericality: { in: 1..9 }

  def marketing_image_url
    if marketing.attached?
      Rails.application.routes.url_helpers.url_for(marketing)
    else
      # Return path to default image
      ActionController::Base.helpers.asset_path("default_course_image.jpg")
    end
  end
end
