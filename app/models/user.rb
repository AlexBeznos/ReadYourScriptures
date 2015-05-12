class User < ActiveRecord::Base
  has_many :schedules, :dependent => :destroy

  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :phone, :numericality => true,
                    :length => { :minimum => 10, :maximum => 15 }

  before_create :set_activation_code
  after_create :send_welcome_email

  def set_activation_code
    self.activation_code = SecureRandom.hex(12)

    if User.where(activation_code: self.activation_code).any?
      self.set_activation_code
    end
  end
  def send_welcome_email
    MailSender.welcome(self).deliver
  end
end
