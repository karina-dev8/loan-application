class CreateLoans < ActiveRecord::Migration[7.1]
  def change
    create_table :loans do |t|
      t.string :title
      t.string :description
      t.decimal :loan_amount
      t.decimal :loan_amount
      t.string :loan_status
      t.references :user, null: false, foreign_key: true
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
