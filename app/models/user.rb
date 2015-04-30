class User < ActiveRecord::Base
  has_many :schedules, :dependent => :destroy

  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end

  validates :email, :password, presence: true
  validates :phone,:presence => true,
                   :numericality => true,
                   :length => { :minimum => 10, :maximum => 15 }
end
