class Admin::SchedulesController < AdminController
  def show
    @user = User.find(params[:user_id])
    @schedule = Schedule.includes(:assignments).find(params[:id])
  end
end
