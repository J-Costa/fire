require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @certificate = certificates(:active)
  end

  test 'should show certificate validation form' do
    get new_certificate_url

    assert_response :success
    assert_select "form[action='#{certificates_path}']"
    assert_select "form[data-turbo='false']"
    assert_select "input[name='certificate[code]']"
  end

  test 'should validate certificate code from form' do
    post certificates_url, params: { certificate: { code: "  #{@certificate.code.downcase} " } }

    assert_response :success
    assert_includes response.body, @certificate.code
    assert_includes response.body, 'Certificado válido'
  end

  test 'should render not found for invalid certificate code from form' do
    post certificates_url, params: { certificate: { code: 'INVALID01' } }

    assert_response :not_found
    assert_includes response.body, 'Certificado não encontrado'
  end

  test 'should validate certificate through direct code link' do
    get certificate_url(@certificate.code)

    assert_response :success
    assert_includes response.body, @certificate.code
    assert_includes response.body, @certificate.course.name
    assert_includes response.body, @certificate.user.name
  end

  test 'should show active certificate as expired after its expiration date' do
    expired_certificate = certificates(:active)
    expired_certificate.update!(expires_at: 1.day.ago)

    get certificate_url(expired_certificate.code)

    assert_response :success
    assert_includes response.body, 'Certificado expirado'
    refute_includes response.body, 'Certificado válido'
  end

  test 'should return not found for an unknown code' do
    get certificate_url('UNKNOWN01')

    assert_response :not_found
    assert_includes response.body, 'Certificado não encontrado'
  end

  test 'should return too many requests when rate limit is exceeded' do
    Rails.cache.expects(:increment).returns(31)

    get new_certificate_url

    assert_response :too_many_requests
    assert_equal '60', response.headers['Retry-After']
  end
end
