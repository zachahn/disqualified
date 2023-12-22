Disqualified.configure do |config|
  config.logger = Rails.logger
  ActiveRecord::Base.logger = Rails.logger

  config.on_error do |error, context|
    puts "🔥" * 10
    pp error
    pp context
  end
end
