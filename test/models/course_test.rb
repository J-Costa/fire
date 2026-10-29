require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @course = Course.new(name: 'Example Course', description: 'This is an example course description.', featured: 5)
  end

  test 'should be valid' do
    assert @course.valid?
  end

  test 'name should be present' do
    @course.name = ' '

    refute @course.valid?
  end

  test 'description should be present' do
    @course.description = ' '

    refute @course.valid?
  end

  test 'featured should be present' do
    @course.featured = nil

    refute @course.valid?
  end

  test 'name should be unique' do
    duplicate_course = @course.dup
    @course.save

    refute duplicate_course.valid?
  end

  test 'description should have a minimum length' do
    @course.description = 'a' * 9

    refute @course.valid?
  end

  test 'featured should be within range' do
    @course.featured = 10
    refute @course.valid?

    @course.featured = 0
    refute @course.valid?
  end

  test 'certificate paragraphs use program data when available' do
    @course.program_data = {
      'workload_hours' => 40,
      'subjects' => [{ 'Primeiros socorros' => 40 }],
      'descriptions' => [
        { '1' => 'Primeiro parágrafo do certificado.' },
        { '2' => 'Segundo parágrafo do certificado.' }
      ]
    }

    assert_equal 'Primeiro parágrafo do certificado.', @course.certificate_paragraph_1
    assert_equal 'Segundo parágrafo do certificado.', @course.certificate_paragraph_2
    assert_includes @course.program_content, 'Primeiros socorros'
    refute_includes @course.program_content, 'paragraph_1'
  end

  test 'certificate paragraphs fall back to course text' do
    @course.program_data = {}

    assert_equal @course.description, @course.certificate_paragraph_1
    assert_equal @course.description, @course.certificate_paragraph_2
    assert_equal @course.description, @course.program_content
  end
end
