class SchedulesController < ApplicationController
  before_action :find_schedule, only: [:update, :destroy, :toggle]

  def show
    @schedule = Schedule.includes(:assignments).find(params[:id])
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
      redirect_to choose_dates_path, :alert => alert_message
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

    def log_error
      Rails.logger.error "Error happend while choosing date and duration for schedule. error: #{@schedule.errors.inspect}"
    end
end
