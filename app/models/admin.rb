class Admin < User
  attribute :kind, :enum, default: :admin
end
