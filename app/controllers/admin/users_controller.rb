class Admin::UsersController < AdminController
  before_filter :find_user, only: :show

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
  end

  private
    def find_user
      @user = User.includes(:schedules).find(params[:id])
    end
end
