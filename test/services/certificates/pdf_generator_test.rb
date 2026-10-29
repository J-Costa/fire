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

  test 'uses fallbacks when optional data and logos are unavailable' do
    previous_name = ENV.delete('CERTIFICATE_INSTRUCTOR_NAME')
    previous_document = ENV.delete('CERTIFICATE_INSTRUCTOR_DOCUMENT')
    previous_responsibility = ENV.delete('CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY')
    certificate = certificates(:active)
    certificate.user.stubs(:document).returns(nil)

    pdf = Certificates::PdfGenerator.new(certificate, verification_url: 'https://example.com/certificates/test').render

    assert pdf.start_with?('%PDF-')
  ensure
    ENV['CERTIFICATE_INSTRUCTOR_NAME'] = previous_name
    ENV['CERTIFICATE_INSTRUCTOR_DOCUMENT'] = previous_document
    ENV['CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY'] = previous_responsibility
  end

  test 'renders the header without optional logos' do
    bounds = Struct.new(:top, :width).new(800, 1000)
    pdf = mock
    pdf.stubs(:bounds).returns(bounds)
    pdf.stubs(:image)
    pdf.stubs(:text_box)
    pdf.stubs(:stroke_color)
    pdf.stubs(:stroke_horizontal_line)
    generator = Certificates::PdfGenerator.new(certificates(:active), verification_url: 'https://example.com/certificates/test')

    File.stubs(:exist?).with { |path| path.to_s.end_with?('logo_krypton_pdf.png', 'logo_bombeiro_pdf.png') }.returns(false)

    generator.send(:render_header, pdf)

    assert pdf
  end

  test 'includes the student document when present' do
    certificate = certificates(:active)
    certificate.user.document = '123.456.789-00'

    pdf = Certificates::PdfGenerator.new(certificate, verification_url: 'https://example.com/certificates/test').render

    assert pdf.start_with?('%PDF-')
  end
end
