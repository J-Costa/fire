require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  setup do
    @certificate = certificates(:active)
  end

  test 'builds a public certificate URL' do
    assert_equal certificate_url(@certificate.code), certificate_public_url(@certificate)
  end

  test 'builds a QR code SVG' do
    assert_includes certificate_qr_svg(@certificate), '<svg'
  end

  test 'builds a WhatsApp URL with the Brazil country code' do
    @certificate.user.update!(phone: '11912-34567')

    whatsapp_url = certificate_whatsapp_url(@certificate)

    assert_includes whatsapp_url, 'https://wa.me/551191234567?text='
    assert_includes whatsapp_url, ERB::Util.url_encode(@certificate.code)
  end

  test 'does not build a WhatsApp URL for an invalid phone' do
    @certificate.user.update!(phone: '12345')

    assert_nil certificate_whatsapp_url(@certificate)
  end
end
