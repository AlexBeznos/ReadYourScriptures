class UsersController < ApplicationController
  after_action :prepare_schedule, only: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, :notice => 'User successfuly created'
    else
      render :action => :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :phone)
    end

    def prepare_schedule
      if session[:schedule_id]
        schedule = Schedule.find(session[:schedule_id])

        @user.schedules << schedule
        schedule.gen_assignments
      end
    end
end
