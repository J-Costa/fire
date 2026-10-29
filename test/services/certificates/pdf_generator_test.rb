require 'test_helper'

class Certificates::PdfGeneratorTest < ActiveSupport::TestCase
  test 'includes optional instructor data in the PDF' do
    previous_name = ENV['CERTIFICATE_INSTRUCTOR_NAME']
    previous_document = ENV['CERTIFICATE_INSTRUCTOR_DOCUMENT']
    previous_responsibility = ENV['CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY']
    ENV['CERTIFICATE_INSTRUCTOR_NAME'] = 'Diretor Teste'
    ENV['CERTIFICATE_INSTRUCTOR_DOCUMENT'] = '123.456.789-00'
    ENV['CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY'] = 'TST-000000/SP'

    certificate = certificates(:active)
    pdf = Certificates::PdfGenerator.new(certificate, verification_url: 'https://example.com/certificates/test').render

    assert pdf.start_with?('%PDF-')
    assert_operator pdf.bytesize, :>, 10_000
  ensure
    ENV['CERTIFICATE_INSTRUCTOR_NAME'] = previous_name
    ENV['CERTIFICATE_INSTRUCTOR_DOCUMENT'] = previous_document
    ENV['CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY'] = previous_responsibility
  end
end
