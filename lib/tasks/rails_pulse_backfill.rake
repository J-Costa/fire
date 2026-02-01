namespace :rails_pulse do
  namespace :backfill do
    desc 'Backfill Rails Pulse summaries from latest daily period to today'
    task to_today: :environment do
      begin
        # Find the latest daily summary period_start
        latest_period_start = RailsPulse::Summary.where(period_type: 'day').maximum(:period_start)
        today = Date.current
        from_date = latest_period_start ? (latest_period_start.to_date + 1.day) : today
        to_date = today

        if from_date > to_date
          puts "[RailsPulse] Backfill not needed. Up to date (latest=#{latest_period_start})"
          next
        end

        # Try common backfill job names in the RailsPulse ecosystem
        puts "[RailsPulse] Starting backfill from #{from_date} to #{to_date}"
        RailsPulse::BackfillSummariesJob.perform_now(from_date, to_date)
        puts "[RailsPulse] Backfill completed from #{from_date} to #{to_date}"
      rescue => e
        puts "[RailsPulse] Backfill error: #{e.class} - #{e.message}"
        raise e
      end
    end
  end
end
