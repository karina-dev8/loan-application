ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :phone_number, :address, :wallet_amount

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone_number
    column :email
    column :address
    column :wallet_amount
    column :created_at
    actions
  end

  
  filter :email

  form do |f|
    if f.object.new_record?
      f.inputs 'Create Admin User' do
        f.input :first_name
        f.input :last_name
        f.input :phone_number
        f.input :email
        f.input :address
        f.input :wallet_amount
        f.input :password
        f.input :password_confirmation
      end
    else
      f.inputs 'Edit Admin User' do
        f.input :first_name
        f.input :last_name
        f.input :phone_number
        f.input :email
        f.input :address
        f.input :wallet_amount
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :phone_number
      row :email
      row :address
      row :wallet_amount
      row :created_at
      row :updated_at
    end
  end
end
