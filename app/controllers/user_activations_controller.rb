class UserActivationsController < ApplicationController
  def create
    user = User.find_by(activation_code: params[:id])

    if user.update(activated: true, activation_code: nil)
      redirect_to account_path, :notice => 'Your account activated!'
    else
      puts user.errors.inspect
      redirect_to account_path, :alert => 'Something went wrong. Try again later!'
    end

  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError.new('Not Found')
  end
end
