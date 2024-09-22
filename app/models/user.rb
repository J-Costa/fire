class User < ApplicationRecord
  enum :kind, { admin: "admin", student: "student" }
end
