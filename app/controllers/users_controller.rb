class UsersController < ApplicationController
  before_action :logged_in_ser, except: %i(new create show)
  before_action :load_user, except: %i(new create)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.user_number
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".wel_app"
      redirect_to @user
    else
      flash[:danger] = t ".error_signup"
      render :new
    end
  end

  def show
    return if @user
      flash[:danger] = t ".not_found"
      redirect_to signup_path
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".pro_updated"
      redirect_to @user
    else
      flash[:danger] = t ".pro_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".del_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".please_login"
    redirect_to login_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".not_found"
    redirect_to home_path
  end
end
