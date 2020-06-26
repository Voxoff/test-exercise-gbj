require_relative '../../config/environment'

desc "Creates Deliveries for 'billed' orders on a custom date"

task :shipping, [:date] do |t, args|
  if args[:date].nil? || !args[:date].match(/\d{2}\/\d{2}\/\d{2}/)
    puts "Expects date format: yy/mm/dd"
    next # Break out of rake task
  end
  date = Date.parse(args[:date])
  Order.create_deliveries_on(date)

  puts "Orders created for #{args[:date]}!"
end
