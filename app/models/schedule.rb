class Schedule < ActiveRecord::Base
  has_and_belongs_to_many :books
  has_many :assignments
  belongs_to :user

  validates :step, presence: true
  validates :start_date, :name, :duration, presence: true, unless: 'step == 1'
  validates :user_id, presence: true, if: 'step == 3'
end
