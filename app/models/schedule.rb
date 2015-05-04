include ActionView::Helpers::DateHelper

class Schedule < ActiveRecord::Base
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

  def create_part_per_day_assignments
    day_from_start = -1
    self.books.each do |book|
      book.parts_number.times do |time|
        day_from_start =+ 1
        Assignment.create(name: "#{book.name} #{time + 1}",
                          sending_date: day_from_start + self.start_date,
                          schedule_id: self.id)
      end
    end
  end

  def create_regular_assignments(sum)
    div = sum / self.duration
    mod = sum % self.duration
    names = []

    self.get_name(0, div, mod, true, 0, first: true)
  end

  def get_name(book_num, div, mod, day_from, **prev)
    book = self.books[book_num]
    sum = div + mod
    arr = []
    if mod != 0
      if book.parts_number > sum
        if prev[:first]
          arr.push("#{book.name} 1 - #{sum}")
        else
          arr.push("#{prev[:book_name]} #{prev[:part]} - #{book.name} #{sum}")
        end

        till = 0
        ((book.parts_number - (div + mod)) / div).times do |time|
          real_time = time + 1
          from = real_time == 1 ? (sum) : (real_time * div) + mod
          till = from + div

          arr.push("#{book.name} #{ from } - #{ till }")
        end

        new_day_from = self.create_assignments_from_array(arr, day_from)
        new_mod = (book.parts_number - (div + mod)) % div

        hash = {}
        unless new_mod == 0
          hash =  {:book_name => book.name, :part => till}
        end

        self.get_name(book_num + 1, div, new_mod, new_day_from, hash)
      else
        if prev[:first]
          hash = {:book_name => book.name, :part => 1}
        else
          hash = prev
        end
        self.get_name(book_num + 1, div, mod - book.parts_number, day_from, hash )
      end
    else
      till = 0

      (book.parts_number / div).times do |time|
        real_time = time + 1
        from = real_time == 1 ? div : real_time * div
        till = from + div

        arr.push("#{book.name} #{ from } - #{ till }")
      end

      new_day_from = self.create_assignments_from_array(arr, day_from)
      new_mod = book.parts_number % div

      hash = {}
      unless new_mod == 0
        hash =  {:book_name => book.name, :part => till}
      end

      self.get_name(book_num + 1, div, new_mod, new_day_from, hash)
    end
  end

  def create_assignments_from_array(arr, day_from)
    arr.each do |name|
      Assignment.create(name: name, sending_date: self.start_date + day_from, schedule_id: self.id)
      day_from =+ 1
    end

    day_from
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
              if books.where(testament: Book.testaments[:new_testament]).count == 27
                'New testament'
              else
                many
              end
            when 39
              if books.where(testament: Book.testaments[:old_testament]).count == 39
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
