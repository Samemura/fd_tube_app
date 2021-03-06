# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :ensure_normal_user, only: :destroy

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  def destroy
    user = User.find(params[:id])

    soft_delete(user)
    flash[:alert] = 'ユーザーを削除しました'
    yield resource if block_given?
    respond_with_navigational { redirect_to users_path }
  end

  def ensure_normal_user
    redirect_to videos_path, alert: 'ゲストユーザーは削除できません' if resource.email == 'guest@example.com'
  end

  private

  def soft_delete(user)
    deleted_email = user.email + '_deleted_' + I18n.l(Time.current, format: :delete_flag)
    user.assign_attributes(email: deleted_email, delete_at: Time.current)
    user.skip_email_changed_notification!
    user.save!
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
