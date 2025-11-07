class Course < ApplicationRecord
  FEATURED_RANGE = 1..9

  has_many :enrollments
  has_many :students, through: :enrollments
  has_one_attached :marketing

  validates :name, :description, :featured, presence: true
  validates :name, uniqueness: true
  validates :description, length: { minimum: 10 }
  validates :featured, numericality: { in: FEATURED_RANGE }
end
