class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
#＝＝＝＝＝＝＝＝＝＝DM機能＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 
  # currentUserと[chatへ]を押されたユーザーの両方をEntrisテーブルに記録する必要があるため、
  # whereメソッドで両側のユーザーを探している
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
  # unlessは・・でない場合
    unless @user.id == current_user.id
      # roomが作成されている場合：each doで両者側からのroom_idを取り出して特定する、
      # cとuのroom_idが＝＝なら、@roomIDでroom_idを特定する
      @currentUserEntry.each do |c|
        @userEntry.each do |u|
          if c.room_id == u.room_id then
            # この＠isRoom=trueはfalseの時に条件を分岐するため
            @isRoom = true
            @roomId = c.room_id
          end
        end
      end
      # この＠isRoomはもしtureではなく、falseだった時にelseの処理をするため
      if @isRoom
        # 新しい、RoomとEntryを作る
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
#＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
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
