require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '1m' do
  Rails.logger.info 'Scheduler is functioning'
end

scheduler.every '3h' do
  Rails.logger.info 'Unneeded schedulers deleting'
  Schedule.where("created_at < ? and user_id = ?", 2.hours.ago, nil).destroy_all
end

scheduler.cron("0 9 * * *") do
  Rails.logger.info 'Assignments start sending'
  sender = AssignmentSender.new
  sender.find_assignments
  sender.notify
end
