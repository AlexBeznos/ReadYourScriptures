class User < ActiveRecord::Base
  has_many :schedules, :dependent => :destroy

  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end

  enum notification_type: [:email, :sms, :email_and_sms]

  validates :email, :password, :notification_type, presence: true
  validates :phone, :presence => true,
                    :numericality => true,
                    :length => { :minimum => 10, :maximum => 15 },
                    :if => :sms_included?

  before_create :set_phone, :if => :sms_included?

  def sms_included?
    puts 'notification'
    puts self.notification_type
    puts [:sms, :email_and_sms].include?(self.notification_type.to_sym)
    [:sms, :email_and_sms].include?(self.notification_type.to_sym)
  end

  def set_phone
    self.phone = nil
  end
end
