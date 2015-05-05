include ActionView::Helpers::DateHelper

class Schedule < ActiveRecord::Base
  include AssignmentCreationHelper

  has_and_belongs_to_many :books
  has_many :assignments, :dependent => :destroy
  belongs_to :user

  before_validation :gen_name, if: 'step == 2'

  validates :step, presence: true
  validates :start_date, :name, :duration, presence: true, unless: 'step == 1'
  validates :user_id, presence: true, if: 'step == 3'

  def gen_name
    self.name = "#{self.gen_name_book_part} in #{distance_of_time_in_words(Time.now, self.duration.days.from_now)}"
  end

  def gen_assignments
    sum = self.books.sum(:parts_number)
    if sum < self.duration
      self.create_part_per_day_assignments
    else
      self.create_regular_assignments(sum)
    end
  end

  def toggle
    if self.active
      self.update(active: false)
    else
      self.update(active: true)
      today = Date.today

      if self.assignments.first.sending_date <= today
        self.assignments.where(sended: false).each_with_index do |assignment, index|
          assignment.update(sending_date: today + index)
        end
      end
    end
  end

  def gen_name_book_part
    books = self.books
    many = "#{books.first.name}, #{books.second.name} and others"

    return  case books.count
            when 1
              books.first.name
            when 2
              "#{books.first.name} and #{books.last.name}"
            when 3
              "#{books.first.name}, #{books.second.name} and #{books.last.name}"
            when 27
              if books.where(book_type: Book.book_types[:new_testament]).count == 27
                'New testament'
              else
                many
              end
            when 39
              if books.where(book_type: Book.book_types[:old_testament]).count == 39
                'Old testament'
              else
                many
              end
            when 66
              'The Bible'
            else
              many
            end
  end
end