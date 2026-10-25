release: bundle exec rails db:migrate && bundle exec rake rails_pulse:backfill:to_today && bundle exec rake certificates:expire
web: bundle exec rails server