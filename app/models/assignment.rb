class Assignment < ActiveRecord::Base
  default_scope -> { order(:sending_date) }

  belongs_to :schedule
end
