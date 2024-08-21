class Loan < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, optional: true

  validates :loan_amount, presence: true, numericality: { greater_than: 0 }
end