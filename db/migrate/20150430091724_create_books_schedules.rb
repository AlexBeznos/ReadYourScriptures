class CreateBooksSchedules < ActiveRecord::Migration
  def change
    create_table :books_schedules do |t|
      t.integer :book_id
      t.integer :schedule_id
    end

    add_index :books_schedules, :book_id
    add_index :books_schedules, :schedule_id
  end
end
