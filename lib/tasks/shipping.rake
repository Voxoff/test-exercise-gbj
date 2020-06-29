require_relative '../../config/environment'

desc "Creates deliveries for 'billed' orders on a date entered (yyyy-mm-dd)"

task :shipping, [:date] do |t, args|
  if args[:date].nil? || !args[:date].match(/\d{4}-\d{2}-\d{2}/)
    puts "Expects date format: yyyy-mm-dd"
    next # Break out of rake task
  end
  date = Date.parse(args[:date])
  DeliveryHelper.new(date: date).create_deliveries

  puts "Orders created for #{args[:date]}"
end
