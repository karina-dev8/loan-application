namespace :loan do
  desc "Calculate interest on loans"
  task calculate_interest: :environment do
    CalculateLoanInterestWorker.perform_async
  end

  desc "Repay loans when the loan amount exceeds the users wallet amount"
  task repay_loan: :environment do
    LoanRepaymentWorker.perform_async
  end
end