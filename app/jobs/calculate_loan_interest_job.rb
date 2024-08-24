class CalculateLoanInterestJob < ApplicationJob
  queue_as :default

  def perform
    Loan.open.find_each do |loan|
      interest = loan.loan_amount * (loan.interest_rate / 100.0)
      loan.update(loan_amount: loan.loan_amount + interest)
    end
  end
end
