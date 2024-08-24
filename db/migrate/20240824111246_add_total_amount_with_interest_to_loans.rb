class AddTotalAmountWithInterestToLoans < ActiveRecord::Migration[7.1]
  def change
    add_column :loans, :total_amount_with_interest, :decimal
  end
end
