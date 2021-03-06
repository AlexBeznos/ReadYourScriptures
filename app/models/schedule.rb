require 'icalendar'
include ActionView::Helpers::DateHelper

class Schedule < ActiveRecord::Base
  include AssignmentCreationHelper

  default_scope -> { order(:created_at => :desc) }

  has_and_belongs_to_many :books
  has_many :assignments, :dependent => :destroy
  belongs_to :user

  before_validation :gen_name, if: 'step == 2'

  validates :step, presence: true
  validates :start_date, :name, :duration, presence: true, unless: 'step == 1'
  validates :user_id, presence: true, if: 'step == 3'

  before_update :check_user_activation
  after_update :send_first_assignment, if: 'active == true'

  def gen_name
    self.name = "#{self.gen_name_book_part} in #{distance_of_time_in_words(Time.now, self.duration.days.from_now)}"
  end

  def check_user_activation
    user = self.user

    if user
      if user.activated == false
        self.active = false
        self.user = user
      end
    end
  end

  def send_first_assignment
    assignment = self.assignments[0]
    now = Time.now
    today = Date.today

    if assignment.sending_date == today && now.hour > 9
      MailSender.assignment_notification(assignment).deliver
      assignment.update(sended: true)
    end
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

    return  case books.count
            when 1
              books.first.name
            when 2
              "#{books.first.name} and #{books.last.name}"
            when 3
              "#{books.first.name}, #{books.second.name} and #{books.last.name}"
            when 27
              if books.where(book_category_id: 1).count == 27
                'New testament'
              else
                "#{books.first.name}, #{books.second.name} and others"
              end
            when 39
              if books.where(book_category_id: 2).count == 39
                'Old testament'
              else
                "#{books.first.name}, #{books.second.name} and others"
              end
            when 66
              'The Bible'
            else
              "#{books.first.name}, #{books.second.name} and others"
            end
  end

  def to_ical
    cal = Icalendar::Calendar.new

    assignments.each do |assignment|
      event = Icalendar::Event.new
      event.dtstart = assignment.sending_date.to_date
      event.summary = assignment.name
      event.url = Rails.application.routes.url_helpers.schedule_url(self)
      cal.add_event(event)
    end

    cal.to_ical
  end
end
