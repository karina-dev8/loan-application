class ChangeAdminUserIdNullOnLoans < ActiveRecord::Migration[7.1]
  def change
    change_column_null :loans, :admin_user_id, true
    change_column_null :loans, :user_id, true
  end
end
