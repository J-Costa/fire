class Course < ApplicationRecord
  FEATURED_RANGE = 1..9

  has_many :enrollments
  has_many :students, through: :enrollments
  has_one_attached :marketing

  validates :name, :description, :featured, presence: true
  validates :name, uniqueness: true
  validates :description, length: { minimum: 10 }
  validates :featured, numericality: { in: FEATURED_RANGE }
  validate :program_data_json_is_valid

  def program_data_json
    JSON.pretty_generate(program_data || {})
  end

  def program_data_json=(value)
    self.program_data = JSON.parse(value)
    @program_data_json_error = nil
  rescue JSON::ParserError => error
    @program_data_json_error = error.message
  end

  def certificate_paragraph_1
    program_description(1).presence || description
  end

  def certificate_paragraph_2
    program_description(2).presence || details.presence || description
  end

  def program_content
    content = []
    workload_hours = program_value(:workload_hours)
    content << "Carga horária: #{workload_hours} horas" if workload_hours.present?
    content << 'Matérias:' if program_subjects.any?
    content.concat(program_subjects.map { |subject| "- #{subject[:name]}: #{subject[:hours]} horas" })

    content.presence&.join("\n") || details.presence || description
  end

  def program_subjects
    Array(program_value(:subjects)).filter_map do |subject|
      next unless subject.is_a?(Hash)

      name, hours = subject.first
      next if name.blank?

      { name: name.to_s.strip, hours: hours.to_i }
    end
  end

  def program_workload_hours
    program_value(:workload_hours).to_i
  end

  def program_descriptions
    {
      1 => program_description(1),
      2 => program_description(2)
    }
  end

  private

  def program_data_json_is_valid
    return unless @program_data_json_error

    errors.add(:program_data_json, "não é um JSON válido: #{@program_data_json_error}")
  end

  def program_value(key)
    data = program_data.is_a?(Hash) ? program_data : {}
    data[key.to_s] || data[key.to_sym]
  end

  def program_description(number)
    descriptions = Array(program_value(:descriptions))
    key = number.to_s
    description = descriptions.find do |item|
      item.is_a?(Hash) && item.key?(key)
    end

    return unless description

    description[key]
  end
end
