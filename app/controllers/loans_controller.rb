class LoansController < ApplicationController
  protect_from_forgery with: :exception, except: [:repay, :reject_loan, :approve_loan]

  def index
    @loans = Loan.where(user_id: current_user.id)
  end

  def create
    @loan = Loan.new(loan_params)
    respond_to do |format|
      if @loan.save
        format.html { redirect_to loan_path(@loan), notice: "Loan created successfully." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject_loan
    @loan = Loan.find_by(id: params[:id])
    respond_to do |format|
      if @loan.update(loan_status: "rejected")
        format.html { redirect_to loan_path(@loan), notice: "Loan Rejected successfully." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def approve_loan
    @loan = Loan.find_by(id: params[:id])
    previous_status = @loan.loan_status

    respond_to do |format|
      if @loan.update(loan_status: "open")
        if @loan.loan_status == "open" && previous_status != "open"
          process_loan_approval(@loan)
        end
        format.html { redirect_to loan_path(@loan), notice: "Loan Approved successfully." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def repay
    @loan = Loan.find(params[:id])
    if current_user.total_amount >= @loan.loan_amount
      if @loan.repay_loan!
        flash[:notice] = "Loan repaid successfully."
      else
        flash[:alert] = "Loan repayment failed."
      end
    else
      flash[:alert] = "Insuffesiant balance."
    end
    redirect_to loan_path(@loan)
  end

  def edit
    @loan = Loan.find_by(id: params[:id])
  end

  def update
    @loan = Loan.find_by(id: params[:id])
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to loan_path(@loan), notice: "Loan updated successfully." }
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
    @loan = Loan.find_by(id: params[:id])
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
      flash[:error] = "Don't have sufficient funds to approve this loan."
      redirect_back(fallback_location: root_path) and return
    end
  end

  def loan_params
    params.require(:loan).permit(
      :title,
      :description,
      :interest_rate,
      :loan_amount,
      :user_id,
      :loan_status
    )
  end
end