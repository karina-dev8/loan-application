class LoansController < ApplicationController
  def index
    @loan = Loan.where(user_id: params[:user_id])
  end

  def create
    @loan = Loan.new(loan_params)
    respond_to do |format|
      if @loan.save
        format.html { redirect_to loans_path(@loan), notice: "Loan created successfully." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @loan = Loan.new
  end

  def show
    @loan = Loan.find(params[:id])
  end

  private

  def loan_params
    params.require(:loan).permit(
      :title,
      :description,
      :interest_rate,
      :loan_amount
    )
  end
end