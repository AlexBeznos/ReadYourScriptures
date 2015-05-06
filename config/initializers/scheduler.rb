require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '15m' do
  Rails.logger.info 'Scheduler is functioning'
end

scheduler.every '3h' do
  Schedule.where("created_at < ? and user_id = ?", 2.hours.ago, nil).destroy_all
end

scheduler.cron("0 9 * * *") do
  sender = AssignmentSender.new
  sender.find_assignments
  sender.notify
end
