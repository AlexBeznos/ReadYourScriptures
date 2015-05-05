class AddNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :notification_type, :integer, :default => 0
  end
end
