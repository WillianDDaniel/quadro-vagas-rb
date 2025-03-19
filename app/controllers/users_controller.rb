class UsersController < ApplicationController
  before_action :only_admin_access, only: %i[ index toggle_status ]
  before_action :set_user, only: %i[ toggle_status ]

  def index
    @users = User.unscoped.order(:name)
  end

  def toggle_status
    return redirect_to users_path, alert: t(".change_admin_status_alert") if @user.admin?

    @user.toggle_status!
    redirect_to users_path, notice: t(".success")
  end

  private

  def set_user
    @user = User.unscoped.find(params[:id])
  end
end
