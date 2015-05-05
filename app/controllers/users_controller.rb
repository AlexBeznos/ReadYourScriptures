class UsersController < ApplicationController
  before_action :require_user, only: :show
  after_action :prepare_schedule, only: :create

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to account_path, :notice => 'User successfuly created'
    else
      render :action => :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :phone, :notification_type)
    end
end
