require 'prawn'
require 'stringio'
require 'chunky_png'

Prawn::Fonts::AFM.hide_m17n_warning = true

module Certificates
  class PdfGenerator
    def initialize(certificate, verification_url:, school_data: SchoolData.new, instructor_data: InstructorData.new)
      @certificate = certificate
      @verification_url = verification_url
      @school_data = school_data
      @instructor_data = instructor_data
    end

    def render
      pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, margin: 42, info: pdf_metadata)

      render_first_page(pdf)
      pdf.start_new_page
      render_second_page(pdf)

      pdf.render
    end

    private

    attr_reader :certificate, :verification_url, :school_data, :instructor_data

    def render_first_page(pdf)
      draw_border(pdf)
      render_header(pdf)
       top = pdf.bounds.top
       pdf.text_box pdf_text(certificate.course.certificate_paragraph_1),
              at: [48, top - 182], width: pdf.bounds.width - 96, height: 70,
              align: :center, size: 11, leading: 4
       pdf.text_box pdf_text(certificate.user.name),
              at: [48, top - 277], width: pdf.bounds.width - 96, height: 34,
              align: :center, size: 24, style: :bold
      pdf.text_box "CPF: #{certificate.user.document || '123.456.789-09'}",
              at: [48, top - 314], width: pdf.bounds.width - 96, height: 20,
              align: :center, size: 11, color: '444444'
       render_certificate_period(pdf, top: top)
      render_first_page_footer(pdf)
    end

    def render_header(pdf)
      top = pdf.bounds.top
      krypton_logo_path = Rails.root.join('app/assets/images/pdf/logo_krypton_pdf.png')
      firefighter_logo_path = Rails.root.join('app/assets/images/pdf/logo_bombeiro_pdf.png')

      pdf.image krypton_logo_path, at: [20, top - 10], width: 76 if File.exist?(krypton_logo_path)
      pdf.image firefighter_logo_path, at: [pdf.bounds.width - 96, top - 10], width: 76 if File.exist?(firefighter_logo_path)
      pdf.text_box 'CERTIFICADO',
                   at: [100, top - 40], width: pdf.bounds.width - 200, height: 44,
                   align: :center, size: 38, style: :bold, color: '111111'
      pdf.text_box pdf_text(school_data.name.upcase),
                   at: [100, top - 94], width: pdf.bounds.width - 200, height: 24,
                   align: :center, size: 16, style: :bold, color: 'C81924'
      pdf.text_box pdf_text(school_data.description.upcase),
                   at: [100, top - 120], width: pdf.bounds.width - 200, height: 18,
                   align: :center, size: 10, style: :bold, color: 'C81924'
      pdf.text_box pdf_text(school_data.credential),
                   at: [100, top - 150], width: pdf.bounds.width - 200, height: 16,
                   align: :center, size: 8, color: '444444'
      pdf.stroke_color 'C81924'
      pdf.stroke_horizontal_line 80, pdf.bounds.width - 80, at: top - 160
    end

    def render_certificate_period(pdf, top:)
      period = "Emitido em #{I18n.l(certificate.issued_at.to_date, format: :long)} | Válido até #{I18n.l(certificate.expires_at.to_date, format: :long)}"
      pdf.text_box pdf_text(period), at: [0, top - 332], width: pdf.bounds.width, height: 20, align: :center, size: 12, color: '555555'
      pdf.text_box pdf_text("Código de validação: #{certificate.code}"), at: [0, top - 357], width: pdf.bounds.width, height: 20, align: :center, size: 11, color: '555555'
    end

    def render_first_page_footer(pdf)
      footer_y = 120
      pdf.stroke_color '222222'
      pdf.stroke_line 90, footer_y, 260, footer_y
      pdf.stroke_line pdf.bounds.width - 260, footer_y, pdf.bounds.width - 90, footer_y
      pdf.text_box pdf_text(certificate.user.name), at: [90, footer_y - 6], width: 170, height: 20, align: :center, size: 10, style: :bold
      pdf.text_box pdf_text("Aluno | CPF: #{certificate.user.document || '123.456.789-09'}"), at: [90, footer_y - 24], width: 170, height: 20, align: :center, size: 9
      pdf.text_box pdf_text(instructor_data.name || instructor_data.position), at: [pdf.bounds.width - 260, footer_y - 6], width: 170, height: 20, align: :center, size: 10, style: :bold
      pdf.text_box pdf_text("CPF: #{instructor_data.document || '123.456.789-09'}"), at: [pdf.bounds.width - 260, footer_y - 24], width: 170, height: 20, align: :center, size: 9
      pdf.text_box pdf_text(instructor_data.position), at: [pdf.bounds.width - 260, footer_y - 42], width: 170, height: 20, align: :center, size: 9
      if instructor_data.document.present?
        pdf.text_box pdf_text("CPF: #{instructor_data.document}"), at: [pdf.bounds.width - 260, footer_y - 24], width: 170, height: 20, align: :center, size: 9
      end
      if instructor_data.technical_responsibility.present?
        pdf.text_box pdf_text(instructor_data.technical_responsibility), at: [pdf.bounds.width - 260, footer_y - 58], width: 170, height: 24, align: :center, size: 8
      end

      qr_png = RQRCode::QRCode.new(verification_url).as_png(size: 260, border_modules: 2)
      pdf.image StringIO.new(qr_png.to_blob), width: 58, at: [(pdf.bounds.width - 58) / 2, footer_y + 23]
      pdf.text_box 'QR Code de validação', at: [(pdf.bounds.width - 150) / 2, footer_y - 42], width: 150, height: 18, align: :center, size: 8, color: '666666'
    end

    def render_second_page(pdf)
      draw_border(pdf)
      top = pdf.bounds.top
      pdf.text_box pdf_text(certificate.course.certificate_paragraph_2),
                   at: [48, top - 58], width: pdf.bounds.width - 96, height: 105,
                   align: :center, size: 10, leading: 3
      pdf.text_box pdf_text('CONTEÚDO PROGRAMÁTICO'),
                   at: [0, top - 120], width: pdf.bounds.width, height: 28,
                   align: :center, size: 22, style: :bold, color: 'C81924'
      render_subject_table(pdf, top: top - 160)
      pdf.text_box pdf_text("#{school_data.document} | #{school_data.phone}"), at: [0, 68], width: pdf.bounds.width, height: 18, align: :center, size: 9
      pdf.text_box pdf_text(school_data.address), at: [0, 55], width: pdf.bounds.width, height: 18, align: :center, size: 8, color: '555555'
      pdf.text_box pdf_text("#{school_data.name} | #{school_data.city}"), at: [0, 45], width: pdf.bounds.width, height: 18, align: :center, size: 8, color: '555555'
    end

    def draw_border(pdf)
      pdf.fill_color 'F50000'
      pdf.fill_rectangle [0, pdf.bounds.top], pdf.bounds.width, pdf.bounds.height
      pdf.fill_color 'FFFFFF'
      pdf.fill_rectangle [18, pdf.bounds.top - 18], pdf.bounds.width - 36, pdf.bounds.height - 36
      pdf.stroke_color 'F50000'
      pdf.line_width 2
      pdf.stroke_rectangle [28, pdf.bounds.top - 28], pdf.bounds.width - 56, pdf.bounds.height - 56
      pdf.line_width 1
      pdf.stroke_color 'E8A0A4'
      pdf.stroke_rectangle [36, pdf.bounds.top - 36], pdf.bounds.width - 72, pdf.bounds.height - 72
      pdf.fill_color '111111'
    end

    def render_subject_table(pdf, top:)
      rows = [['MATÉRIAS', 'HORAS (TEÓRICA E PRÁTICA)']]
      rows.concat(certificate.course.program_subjects.map { |subject| [pdf_text("• #{subject[:name]}"), subject[:hours].to_s.rjust(2, '0')] })
      rows << ['TOTAL', certificate.course.program_workload_hours.to_s]

      table_width = pdf.bounds.width * 0.82
      first_column_width = table_width * 0.63
      second_column_width = table_width - first_column_width
      row_height = 25
      left = (pdf.bounds.width - table_width) / 2
      rows.each_with_index do |row, index|
        y = top - (index * row_height)
        pdf.fill_color(index.zero? ? 'F4F4F4' : 'FFFFFF')
        pdf.fill_rectangle [left, y], table_width, row_height
        pdf.stroke_color '222222'
        pdf.stroke_rectangle [left, y], table_width, row_height
        pdf.stroke_line left + first_column_width, y, left + first_column_width, y - row_height
        text_color = index == rows.length - 1 ? 'C81924' : '111111'
        pdf.fill_color text_color
        pdf.text_box row[0].to_s, at: [left + 8, y - 7], width: first_column_width - 16, height: 18,
               size: 10, style: :bold, overflow: :shrink_to_fit
        pdf.text_box row[1].to_s, at: [left + first_column_width, y - 7], width: second_column_width, height: 18,
               size: 10, style: :bold, align: :center, overflow: :shrink_to_fit
      end

      pdf.fill_color '111111'
      pdf.move_down rows.length * row_height
    end

    def pdf_metadata
      {
        Title: "Certificado - #{certificate.user.name}",
        Author: school_data.name,
        Subject: "Certificado de conclusão - #{certificate.course.name}",
        Keywords: "certificado, #{certificate.code}, #{certificate.course.name}",
        Creator: school_data.name
      }
    end

    def pdf_text(text)
      text
    end
  end
end
