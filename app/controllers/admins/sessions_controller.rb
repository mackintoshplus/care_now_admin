# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  before_action :configure_sign_in_params, only: [:create]

  protected
  
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:extra_attribute])
  end

  def after_sign_in_path_for(resource)
  # 例: 管理者のダッシュボードページにリダイレクト
  admin_dashboard_path
  end

  def create
  # 何らかのカスタムロジック
  super
  flash[:notice] = "カスタムメッセージ: ログインに成功しました！"
  end

  
end
