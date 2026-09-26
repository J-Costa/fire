class Certificate < ApplicationRecord
  belongs_to :enrollment
  has_one :user, through: :enrollment
  has_one :course, through: :enrollment

  enum :status, { active: 'active', expired: 'expired', revoked: 'revoked' }

  validates :code, presence: true, uniqueness: true
  validates :expires_at, :issued_at, presence: true

  before_validation :generate_unique_code, on: :create
  before_validation :set_expires_at_and_issued_at, on: :create


  def valid_certificate?
    active? && expires_at.present? && expires_at > Time.current
  end

  private

  def generate_unique_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end

  def set_expires_at_and_issued_at
    self.expires_at ||= 1.year.from_now
    self.issued_at ||= Time.current
  end
end
