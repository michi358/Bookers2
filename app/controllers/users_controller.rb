class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
    redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  # url users users_path
  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end
  
  def is_matching_login_user
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end

end
