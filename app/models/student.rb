class Student < User
  default_scope { where(kind: :student) }

  PHONE_MINMAX_LENGTHS = {
    minimum: 10,
    maximum: 11
  }

  attribute :kind, :enum, default: :student

  has_many :enrollments, foreign_key: :user_id

  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: PHONE_MINMAX_LENGTHS

  scope :not_contacted, -> { where(contacted: false) }

  private

  def password_required?
    false
  end
end
