class Student < User
  attribute :kind, :enum, default: :student

  has_many :enrollments

  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { minimum: 10, maximum: 11 }

  private

  def password_required?
    false
  end
end
