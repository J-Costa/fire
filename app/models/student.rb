class Student < User
  attribute :kind, :enum, default: :student
end
