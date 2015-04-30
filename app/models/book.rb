class Book < ActiveRecord::Base
  enum testament: [:new_testament, :old_testament]

  validates :testament, :name, :parts_number, presence: true
end
