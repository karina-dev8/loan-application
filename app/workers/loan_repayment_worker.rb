class LoanRepaymentWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'calculation-queue'

  def perform
    Loan.open.find_each do |loan|
      user = loan.user
      admin = loan.admin_user

      total_loan_amount = loan.total_amount_with_interest

      if user.total_amount < total_loan_amount
        amount_to_transfer = user.total_amount
      end

      if amount_to_transfer
        ActiveRecord::Base.transaction do
          user.update!(total_amount: user.total_amount - amount_to_transfer)
          admin.update!(wallet_amount: admin.wallet_amount + amount_to_transfer)
          loan.update!(total_amount_with_interest: loan.total_amount_with_interest - amount_to_transfer)
          loan.update!(loan_status: 'closed')
        end
      end
    end
  end
end
