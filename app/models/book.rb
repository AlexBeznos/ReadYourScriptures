class Book < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  
  enum testament: [:new_testament, :old_testament]

  validates :testament, :name, :parts_number, presence: true
end
