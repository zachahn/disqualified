Disqualified.configure_server do |config|
  config.delay_high = 5.0
  config.delay_low = 1.0
  config.logger = Rails.logger
  config.pool_size = 5
  config.claim_duration = 10.minutes
  config.on_error do |exception, context|
    puts "Unhandled Disqualified error"
    pp exception
    pp context
  end
end
