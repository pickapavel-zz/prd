class SessionsController < ApplicationController

  layout 'login'

  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Prihlásenie užívateľa prebehlo správne."
      redirect_to new_client_path
    else
      flash[:alert] = if user.present?
                        "Zadané heslo je nesprávne."
                      else
                        "Užívateľ s emailom #{params[:email]} neexistuje."
                      end
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    flash[:success] = "Boli ste odhlásený."
    redirect_to new_session_path
  end

end
