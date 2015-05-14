class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user, :require_user

  def alert_message
    I18n.t 'alert.rest'
  end

  def prepare_schedule
    if session[:schedule_id] && current_user
      schedule = Schedule.includes(:books).find(session[:schedule_id])
      unless schedule.duration == nil
        session[:schedule_id] = nil

        current_user.schedules << schedule
        schedule.gen_assignments
      end
    end
  end

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      redirect_to login_path, alert: I18n.t('alert.authorization') unless current_user
    end
end
