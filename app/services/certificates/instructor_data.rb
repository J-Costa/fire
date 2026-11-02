module Certificates
  class InstructorData
    def name
      ENV.fetch('CERTIFICATE_INSTRUCTOR_NAME', nil)
    end

    def document
      ENV.fetch('CERTIFICATE_INSTRUCTOR_DOCUMENT', nil)
    end

    def position
      'Diretor'
    end

    def technical_responsibility
      ENV.fetch('CERTIFICATE_INSTRUCTOR_TECHNICAL_RESPONSIBILITY', nil)
    end
  end
end
