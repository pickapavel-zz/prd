class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :login_required

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def login_required
    unless current_user
      redirect_to new_session_path, alert: t('prompts.login_required')
    end
  end
end
