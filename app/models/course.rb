class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
  has_one_attached :marketing

  validates :name, :description, :featured, presence: true
  validates :name, uniqueness: true
  validates :description, length: { minimum: 10 }
  validates :featured, numericality: { in: 1..9 }
end
