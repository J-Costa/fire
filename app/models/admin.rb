class Admin < User
  default_scope { where(kind: :admin) }
  attribute :kind, :enum, default: :admin
end
