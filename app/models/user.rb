class User < ApplicationRecord
  enum type: { admin: "admin", student: "student" }
end
