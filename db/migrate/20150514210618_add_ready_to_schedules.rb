class AddReadyToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :ready, :boolean, :default => false
  end
end
