class Loan < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, optional: true
  has_paper_trail only: [:loan_amount, :interest_rate, :loan_status, :total_amount_with_interest]
  validates :loan_status, presence: true
  validates :loan_amount, numericality: { less_than_or_equal_to: 100_000 }

  scope :open, -> { where(loan_status: 'open') }

  def repay_loan!
    user.update!(total_amount: user.total_amount - total_amount_with_interest)
    admin_user.update!(wallet_amount: admin_user.wallet_amount + total_amount_with_interest)
    update!(loan_status: 'closed')
  end

end