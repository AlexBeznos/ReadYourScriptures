class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate


  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      md5_of_password = Digest::MD5.hexdigest(password)
      username == ENV['ADMIN_NAME'] && md5_of_password == ENV['ADMIN_PASS']
    end
  end
end
