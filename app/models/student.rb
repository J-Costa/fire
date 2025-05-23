class Student < User
  default_scope { where(kind: :student) }
  attribute :kind, :enum, default: :student

  has_many :enrollments, foreign_key: :user_id

  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { minimum: 10, maximum: 11 }

  private

  def password_required?
    false
  end
end
