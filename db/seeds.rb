# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = Admin.find_or_create_by(name:    "admin",
                                email:    "admin@admin.com")
unless admin.persisted?
  admin.password = "123456"
  admin.save!
  admin.confirm
end

Course.find_or_create_by(name:        "Bombeiro Civil",
                         description: "Curso de Bombeiro Civil",
                         details:     "Curso de Bombeiro Civil detalhado",
                         featured:    9)

# Adicionar imagem custom para o curso. No app, caso nao exista uma salva ele usa uma default...
# image_path = Rails.root.join('app', 'assets', 'images', 'default_course_image.jpg')
# if File.exist?(image_path)
#   course.marketing.attach(io: File.open(image_path), filename: 'default_course_image.jpg', content_type: 'image/jpeg')
# else
#   puts "WARN: Default course image not found at #{image_path}. Course will be created without an image."
# end

# course.save!

enrollment = Enrollment.first
if enrollment
  certificate = Certificate.find_or_initialize_by(enrollment: enrollment)
  certificate.issued_at ||= Time.current
  certificate.expires_at ||= 1.year.from_now
  certificate.status ||= 'active'
  certificate.save!
else
  puts "No enrollment found. Skipping certificate creation."
end
