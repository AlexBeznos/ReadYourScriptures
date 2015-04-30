class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :step
      t.string :name
      t.date :start_date
      t.boolean :active, :default => false
      t.integer :duration
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :schedules, :user_id
  end
end
