class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_q, :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    if current_user.admin?
      admin_s3files_path
    else
      videos_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[user_name first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[user_name first_name last_name])
  end

  def set_q
    @q = Video.ransack(params[:q])
  end
end
