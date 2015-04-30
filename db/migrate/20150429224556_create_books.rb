class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :testament
      t.string :name
      t.integer :parts_number

      t.timestamps null: false
    end
  end
end
