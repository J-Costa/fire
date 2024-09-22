class Student < User
  attribute :kind, :enum, default: :student

  has_many :enrollments
end
