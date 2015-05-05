class Book < ActiveRecord::Base
  has_and_belongs_to_many :schedules

  enum book_type: [:new_testament, :old_testament, :others]

  validates :book_type, :name, :parts_number, presence: true
end
