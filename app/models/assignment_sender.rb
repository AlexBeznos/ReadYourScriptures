class AssignmentSender
  attr_accessor :assignments

  def find_assignments
    self.assignments = Assignment.includes(schedule: :user).where("sending_date = ? and sended = ?", Time.now, false)
  end

  def notify
    self.assignments.each do |assignment|
      case assignment.schedule.user.notification_type
      when 'email'
        send_email(assignment)
      when 'sms'
        send_sms(assignment)
      when 'email_and_sms'
        send_sms(assignment)
        send_email(assignment)
      end
    end
  end

  private
    def send_email(assignment)
      MailSender.assignment_notification(assignment).deliver
    end

    def send_sms(assignment)
    end
end
