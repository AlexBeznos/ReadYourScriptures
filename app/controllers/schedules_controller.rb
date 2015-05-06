class SchedulesController < ApplicationController
  before_action :find_schedule, only: [:show, :update, :destroy, :toggle]
  before_action :require_proper_user, only: [:show, :toggle, :destroy]
  before_action :validate_association, only: :create

  def show
  end

  def new
    @schedule = Schedule.new
    @books = Book.all
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.step = 1
    @schedule.attributes = {'book_ids' => []}.merge(params[:schedule] || {})

    if @schedule.save
      session[:schedule_id] = @schedule.id
      redirect_to choose_dates_path
    else
      log_error
      redirect_to new_schedule_path, :alert => alert_message
    end
  end

  def toggle
    @schedule.toggle
    redirect_to schedule_path(@schedule)
  end

  def step_2
    @schedule = Schedule.find(session[:schedule_id])
  end

  def update
    if @schedule.update(schedule_params)
      if current_user
        prepare_schedule
        redirect_to schedule_path(@schedule)
      else
        redirect_to signup_path
      end
    else
      log_error
      render :action => :step_2
    end
  end

  def destroy
    @schedule.destroy
    redirect_to account_path
  end

  private
    def schedule_params
      params.require(:schedule).permit(:step, :duration, :start_date, :duration, :book_ids)
    end

    def find_schedule
      @schedule = Schedule.find(params[:id])
    end

    def require_proper_user
      unless current_user && current_user.id == @schedule.user_id
        redirect_to login_path, alert: I18n.t('alert.authorization')
      end
    end

    def validate_association
      book_ids = params[:schedule][:book_ids]
      book_ids.delete('')

      if book_ids.empty?
        redirect_to new_schedule_path, :alert => 'Should be at least one book choosen!'
      end
    end

    def log_error
      Rails.logger.error "Error happend while choosing date and duration for schedule. error: #{@schedule.errors.inspect}"
    end
end
