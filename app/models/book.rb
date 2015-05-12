class Book < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  belongs_to :book_category

  validates :book_category, :name, :parts_number, presence: true
end
