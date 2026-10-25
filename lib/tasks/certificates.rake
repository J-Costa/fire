namespace :certificates do
  desc 'Mark expired certificates with an expired status'
  task expire: :environment do
    expired_count = Certificate.mark_expired!

    puts "[Certificates] #{expired_count} certificate(s) marked as expired"
  end
end
