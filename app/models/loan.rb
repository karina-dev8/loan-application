class Loan < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, optional: true

  validates :loan_amount, presence: true, numericality: { less_than_or_equal_to: 10000 }
end