class AddDetailsToAdminUser < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
    add_column :admin_users, :phone_number, :string
    add_column :admin_users, :address, :text
    add_column :admin_users, :wallet_amount, :decimal
  end
end
