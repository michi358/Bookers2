class BooksController < ApplicationController
  before_action :is_matching_login_user, only:[:edit,:update]
  
  def new
    @book = Book.new
  end

  def create
    @books = Book.all
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
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
  end

    

  def show
    @book = Book.new
    @book_show = Book.find(params[:id])
    @user = @book_show.user
    
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
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
      @book = Book.find(params[:id])
      unless @book.user_id == current_user.id
        redirect_to books_path
      end
  end
end
