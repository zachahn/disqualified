Disqualified.configure_server do |config|
  config.on_error do |error, context|
    puts "🔥" * 10
    pp error
    pp context
  end
end
