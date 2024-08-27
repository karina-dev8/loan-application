class CalculateLoanInterestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'calculation-queue'

  def perform
    Loan.open.find_each do |loan|
      begin
        interest = loan.total_amount_with_interest * (loan.interest_rate / 100.0)
        loan.update(total_amount_with_interest: loan.total_amount_with_interest + interest)
      rescue
        next
      end
    end
  end
end
