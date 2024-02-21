class UsersController < ApplicationController
  #url users/id user_path(current_user.id)
  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def index
    @users = User.all
    
  end

  private
  
  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end
  
end
