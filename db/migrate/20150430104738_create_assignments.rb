class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.boolean :sended, :default => false
      t.date :sending_date
      t.integer :schedule_id

      t.timestamps null: false
    end

    add_index :assignments, :schedule_id
  end
end
