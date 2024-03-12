class BooksController < ApplicationController
  before_action :is_matching_login_user, only:[:edit,:update]

  def new
    @book = Book.new
  end

  def create
    @books = Book.all
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:tag_name].split(nil)
    if @book.save
      @book.save_tag(tag_list)
      flash[:notice] = "You have created book successfully."
       redirect_to book_path(@book.id)
    else
      @user = current_user
      render :index
    end
  end

    # url books_path
  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
    # 過去１週間のいいね数が多い順で投稿を表示させる
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from..to).size
      }.reverse
    
    # book一覧の
    if params[:latest]
     @books = Book.latest
    elsif params[:old]
     @books = Book.old
    elsif params[:star_count]
     @books = Book.star_count
    else
     @books = Book.all
    end
    # タグを取得するコード
    @tag_list = Tag.all
    
  end
  
  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @book_tags = @book.tags
    @user = @book.user
    @book_comment = BookComment.new
    # 閲覧数を増やす
    @book.increment!(:view_count)
   
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  def edit
    @book = Book.find(params[:id])

  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have update book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
    
    def search
    @tag_list = Tag.all  #こっちの投稿一覧表示ページでも全てのタグを表示するために、タグを全取得
    @tag = Tag.find(params[:tag_id])  #クリックしたタグを取得
    @posts = @tag.posts.all           #クリックしたタグに紐付けられた投稿を全て表示
    end
    
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image, :star,:contet)
  end

  def is_matching_login_user
      @book = Book.find(params[:id])
      unless @book.user_id == current_user.id
        redirect_to books_path
      end
  end
end
