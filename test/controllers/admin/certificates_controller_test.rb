require 'test_helper'

class Admin::CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin_one), scope: :admin
  end

  test 'should get index' do
    get admin_certificates_path

    assert_response :success
    assert_match certificates(:active).code, @response.body
    assert_match users(:student_one).name, @response.body
    assert_match courses(:one).name, @response.body
  end

  test 'should filter index by status' do
    get admin_certificates_path, params: { status: 'expired' }

    assert_response :success
    assert_match certificates(:expired).code, @response.body
    refute_match certificates(:active).code, @response.body
    refute_match certificates(:revoked).code, @response.body
    assert_select "a[href='#{admin_certificates_path(status: 'expired')}']", text: 'Certificado expirado'
  end

  test 'should get new' do
    get new_admin_certificate_path

    assert_response :success
    assert_match users(:student_one).name, @response.body
    assert_match courses(:one).name, @response.body
  end

  test 'should get edit' do
    certificate = certificates(:active)
    get edit_admin_certificate_path(certificate)

    assert_response :success
    assert_match users(:student_one).name, @response.body
    assert_match courses(:one).name, @response.body
    assert_match 'Atualizar certificado', @response.body
  end

  test 'should create certificate' do
    assert_difference('Certificate.count') do
      post admin_certificates_path, params: {
        certificate: {
          enrollment_id: enrollments(:two).id,
          issued_at: '2026-10-25T10:00',
          expires_at: '2027-10-25T10:00',
          status: 'active'
        }
      }
    end

    assert_redirected_to admin_certificates_path
    assert_equal 'Certificado cadastrado com sucesso', flash[:notice]

    certificate = Certificate.order(:created_at).last
    assert_equal enrollments(:two), certificate.enrollment
    assert_equal 'active', certificate.status
  end

  test 'should not create certificate with invalid data' do
    assert_no_difference('Certificate.count') do
      post admin_certificates_path, params: {
        certificate: {
          enrollment_id: '',
          issued_at: '',
          expires_at: '',
          status: ''
        }
      }
    end

    assert_response :unprocessable_content
    assert_match 'não pode ficar em branco', @response.body
  end

  test 'should update certificate' do
    certificate = certificates(:active)

    patch admin_certificate_path(certificate), params: {
      certificate: {
        enrollment_id: enrollments(:two).id,
        issued_at: '2026-10-25T10:00',
        expires_at: '2028-10-25T10:00',
        status: 'revoked'
      }
    }

    assert_redirected_to admin_certificates_path
    assert_equal 'Certificado atualizado com sucesso', flash[:notice]

    certificate.reload
    assert_equal enrollments(:two), certificate.enrollment
    assert_equal '2026-10-25', certificate.issued_at.to_date.to_s
    assert_equal '2028-10-25', certificate.expires_at.to_date.to_s
    assert_equal 'revoked', certificate.status
  end

  test 'should update expired certificates in batch' do
    certificates(:active).update_column(:expires_at, 1.day.ago)

    patch expire_admin_certificates_path, params: { status: 'expired' }

    assert_redirected_to admin_certificates_path(status: 'expired')
    assert_equal '1 certificado(s) atualizado(s) como expirado(s)', flash[:notice]
    assert_equal 'expired', certificates(:active).reload.status
  end

  test 'should not update certificate with invalid data' do
    certificate = certificates(:active)

    patch admin_certificate_path(certificate), params: {
      certificate: {
        enrollment_id: '',
        issued_at: '',
        expires_at: '',
        status: ''
      }
    }

    assert_response :unprocessable_content
    assert_match 'não pode ficar em branco', @response.body
    assert_equal enrollments(:one), certificate.reload.enrollment
  end
end
