ActiveAdmin.register Loan do
  permit_params :id, :title, :description, :loan_amount, :loan_status, :interest_rate, :admin_user_id

  collection_action :your_loans, method: :get do
    @loans = Loan.where(admin_user_id: current_admin_user.id)
    render 'your_loans'
  end

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :loan_amount do |loan|
      loan.loan_amount.to_i
    end
    column :interest_rate
    column :loan_status
    column :admin_user
    actions
  end

  controller do
    def update
      @loan = Loan.find(params[:id])
      previous_status = @loan.loan_status

      if @loan.update(permitted_params[:loan])
        if @loan.loan_status == "approved" && previous_status != "approved"
          process_loan_approval(@loan)
        end
        redirect_to admin_loan_path(@loan), notice: "Loan was successfully updated."
      else
        render :edit
      end
    end

    private

    def process_loan_approval(loan)
      admin = loan.admin_user
      user = loan.user
      loan_amount = loan.loan_amount

      if admin.wallet_amount >= loan_amount
        admin.update!(wallet_amount: admin.wallet_amount - loan_amount)
        user.update!(total_amount: user.total_amount + loan_amount)
      else
        flash[:error] = "Admin does not have sufficient funds to approve this loan."
        redirect_back(fallback_location: admin_loan_path(loan)) and return
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :loan_amount, as: :number, min: 0
      f.input :interest_rate
      f.input :loan_status, as: :select, collection: ['requested', 'approved', 'open', 'closed', 'rejected', 'waiting_for_adjustment_acceptance', 'readjustment_requested']
      f.hidden_field :admin_user_id, value: current_admin_user.id
    end
    f.actions
  end

  filter :loan_status

  show do
    attributes_table do
      row :title
      row :description
      row :loan_amount
      row :interest_rate
      row :loan_status
      row :created_at
      row :updated_at
    end
  end
end
