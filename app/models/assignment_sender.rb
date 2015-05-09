class AssignmentSender
  attr_accessor :assignments

  def find_assignments
    self.assignments = Assignment.includes(schedule: :user).where("sending_date = ? and sended = ?", Time.now, false)
  end

  def notify
    self.assignments.each do |assignment|
      if assignment.schedule.active
        send_email(assignment)
        assignment.update(sended: true)
      end
    end
  end

  private
    def send_email(assignment)
      MailSender.assignment_notification(assignment).deliver
    end
end
