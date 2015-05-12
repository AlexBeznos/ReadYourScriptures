class MailSender < ActionMailer::Base
  default from: "ReadYourScriptures <no-replay@readyourscriptures.com>"

  def welcome(user)
    @user = user
    mail to: @user.email, subject: "Welcome to ReadYourScriptures"
  end

  def assignment_notification(assignment)
    @assignment = assignment
    @schedule = assignment.schedule
    @user = @schedule.user

    mail to: @user.email, subject: "Your daily assignment from ReadYourScriptures"
  end
end
