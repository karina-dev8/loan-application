class Loan < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, optional: true

  scope :open, -> { where(loan_status: 'open') }

  def repay_loan!
    user.update!(total_amount: user.total_amount - loan_amount)
    admin_user.update!(wallet_amount: admin_user.wallet_amount + loan_amount)
    update!(loan_status: 'closed')
  end

end