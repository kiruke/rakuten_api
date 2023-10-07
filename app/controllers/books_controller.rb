class BooksController < ApplicationController
  def index
    @books = []
    if params[:title].present? || params[:isbn].present?
      rakuten_result = Book.set_api(title: params[:title], isbn: params[:isbn])
    end
    if rakuten_result.first == :OK
      @books = rakuten_result.last
    elsif rakuten_result.first == :NG
      @errors = rakuten_result.last
    end
  end

  def show
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "DBに登録しました。"
      redirect_to @book
    else
      @books = []
      flash.now[:danger]
      render :index
    end
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :title, :author, :item_price, :item_url, :image_url)
  end
end
