ActiveAdmin.register Loan do
  permit_params :id, :title, :description, :loan_amount, :loan_status, :interest_rate, :admin_user_id

  collection_action :your_loans, method: :get do
    @loans = Loan.where(admin_user_id: current_admin_user.id)
    render 'your_loans'
  end

  collection_action :change_logs, method: :get do
    @versions = PaperTrail::Version.where(whodunnit: current_admin_user.id)
    render 'change_logs'
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
    before_action :set_paper_trail_whodunnit

    private

    def set_paper_trail_whodunnit
      PaperTrail.request.whodunnit = current_admin_user.id
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :loan_amount, as: :number, min: 0
      f.input :interest_rate
      f.input :loan_status, as: :select, collection: ['requested', 'approved', 'closed', 'rejected', 'waiting_for_adjustment_acceptance', 'readjustment_requested']
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
