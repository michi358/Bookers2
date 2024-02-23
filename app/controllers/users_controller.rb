class UsersController < ApplicationController
  #url users/id user_path(current_user.id)
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @book.user_id = current_user.id
    

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
    @book.user_id = current_user.id
  end

  private

  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end

end
