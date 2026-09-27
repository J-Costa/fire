require 'test_helper'

class CertificateTest < ActiveSupport::TestCase
  test 'should not save certificate without enrollment' do
    certificate = Certificate.new(status: :active)

    assert_not certificate.save
    assert_predicate certificate.errors[:enrollment], :present?
  end

  test 'callbacks generate code and dates on create' do
    enrollment = enrollments(:one)
    certificate = Certificate.create!(enrollment: enrollment, status: :active)

    assert_match(/\A[A-Z0-9]{6}\z/, certificate.code)
    assert_in_delta Time.current, certificate.issued_at, 1.second
    assert_in_delta 1.year.from_now, certificate.expires_at, 1.second
  end

  test 'callbacks preserve supplied code and dates' do
    enrollment = enrollments(:one)
    issued_at = 2.days.ago
    expires_at = 2.days.from_now
    certificate = Certificate.create!(
      enrollment: enrollment,
      code: 'CUSTOM01',
      issued_at: issued_at,
      expires_at: expires_at,
      status: :active
    )

    assert_equal 'CUSTOM01', certificate.code
    assert_equal issued_at.to_i, certificate.issued_at.to_i
    assert_equal expires_at.to_i, certificate.expires_at.to_i
  end

  test 'should not save certificate without status' do
    enrollment = enrollments(:one)
    certificate = Certificate.new(enrollment: enrollment)

    assert_not certificate.save
    assert_predicate certificate.errors[:status], :present?
  end

  test 'should not save certificate with a duplicate code' do
    enrollment = enrollments(:one)
    certificate = Certificate.new(enrollment: enrollment, code: certificates(:active).code, status: :active)

    assert_not certificate.save
    assert_predicate certificate.errors[:code], :present?
  end

  test 'should save valid certificate' do
    certificate = Certificate.new(enrollment: enrollments(:one), status: :active)

    assert certificate.save
    assert_predicate certificate, :persisted?
  end

  test 'should reject an unknown status' do
    assert_raises ArgumentError do
      Certificate.new(status: :pending)
    end
  end

  test 'valid_certificate? should return true for active and not expired certificate' do
    certificate = certificates(:active)

    assert_predicate certificate, :valid_certificate?
  end

  test 'valid_certificate? should return false for active certificate past expiration' do
    certificate = certificates(:active)
    certificate.expires_at = 1.day.ago

    assert_not certificate.valid_certificate?
  end

  test 'valid_certificate? should return false for expired certificate' do
    certificate = certificates(:expired)

    assert_not certificate.valid_certificate?
  end

  test 'valid_certificate? should return false for revoked certificate' do
    certificate = certificates(:revoked)

    assert_not certificate.valid_certificate?
  end

  test 'effective_status should return revoked for revoked certificate' do 
    certificate = certificates(:revoked)

    assert_equal :revoked, certificate.effective_status
  end

  test 'effective_status should return expired for expired certificate' do
    certificate = certificates(:expired)

    assert_equal :expired, certificate.effective_status
  end

  test 'effective_status should return expired for active certificate past expiration' do
    certificate = certificates(:active)
    certificate.expires_at = 1.day.ago

    assert_equal :expired, certificate.effective_status
  end

  test 'effective_status should return active for active and not expired certificate' do
    certificate = certificates(:active)

    assert_equal :active, certificate.effective_status
  end
end
