class MailSender < ActionMailer::Base
  default from: "ReadYourScriptures <no-replay@readyourscriptures.com>"

  def welcome(user)
    mail to: user.email, subject: "Welcome to ReadYourScriptures"
  end
end
