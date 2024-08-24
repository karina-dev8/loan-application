class LoanRepaymentWorker
  include Sidekiq::Worker

  def perform
    Loan.open.find_each do |loan|
      user = loan.user
      admin = loan.admin_user

      total_loan_amount = loan.total_amount_with_interest

      if user.total_amount < total_loan_amount
        amount_to_transfer = user.total_amount
      else
        amount_to_transfer = total_loan_amount
      end

      ActiveRecord::Base.transaction do
        user.update!(total_amount: user.total_amount - amount_to_transfer)
        admin.update!(total_amount: admin.total_amount + amount_to_transfer)

        if amount_to_transfer == total_loan_amount
          loan.update!(loan_status: 'closed')
        end
      end
    end
  end
end
