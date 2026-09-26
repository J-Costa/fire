class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many :certificates, dependent: :destroy

  validates :user_id, uniqueness: { scope: :course_id }
end
