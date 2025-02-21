class AdminsController < ApplicationController
  def user_portfolio
    @users = User.where(approved: true)
  end

  def approvals
    @users = User.where(approved: false)
  end

  def approve_account
    @user = User.find(params[:id])
    @user.update(approved: true)
    @user.save
    if @user.save
      ApproveMailer.with(email: @user.email).approve_account_mailer.deliver_now
      redirect_to admins_user_portfolio_path fallback_location: admins_add_user_path, success: 'User Approved'
      flash[:notice] = 'Successfully approved trader registration'
    else
      redirect_to admins_user_portfolio_path fallback_location: admins_add_user_path, danger: 'Approval failed'
    end
  end

  def add_user
    @user = User.new
  end

  def create_user
    @user = User.new(params.require(:user).permit(:email, :password, :confirm_password, :first_name, :last_name, :username))
    @user.save
    if @user.save
      ApproveMailer.with(email: @user.email).approve_account_mailer.deliver_now
      redirect_back fallback_location: admins_add_user_path, success: 'User Created'
      flash[:notice] = 'Successfully created a new trader account'
    else
      redirect_back fallback_location: admins_add_user_path, danger: 'Error in creating a user'
    end
  end

  def view_user
    @user = User.find(params[:id])
  end

  def edit_user
    @user = User.find(params[:id])
  end

  def modify_user
    @user = User.find(params[:id])
    @user.update(params.require(:user).permit(:email, :first_name, :last_name, :username))
    if @user.update(params.require(:user).permit(:email, :first_name, :last_name, :username))
      redirect_to user_profile_path fallback_location: admins_add_user_path, success: 'User updated'
    else
      redirect_back fallback_location: admins_add_user_path, danger: 'Error in updating the user'
    end
  end
end
