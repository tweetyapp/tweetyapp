class AddForgotPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_code, :string
    add_column :users, :reset_code_valid, :datetime
  end

  def self.down
    remove_column :users, :reset_code_valid
    remove_column :users, :reset_code
  end
end
