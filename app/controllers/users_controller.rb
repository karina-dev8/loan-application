class UsersController < ApplicationController
  before_action :user_edit_profile, only: [:home_page]

  def profile
    @user = current_user
  end

  def home_page
  end

  def edit_profile
    @user = User.find_by(id: current_user.id)

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: "Profile Updated successfully." }
      else
        format.html { render :edit }
      end
    end
  end

  def user_edit_profile
    return if current_user.first_name.present?
    @user = current_user
    render partial: 'edit'
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :phone_number,
      :address,
      :email,
      :total_amount
    )
  end
end