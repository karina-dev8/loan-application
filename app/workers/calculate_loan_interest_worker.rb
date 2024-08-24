class CalculateLoanInterestWorker
  include Sidekiq::Worker

  def perform
    Loan.open.find_each do |loan|
      begin
        interest = loan.loan_amount * (loan.interest_rate / 100.0)
        loan.update(loan_amount: loan.loan_amount + interest)
      rescue
        next
      end
    end
  end
end
