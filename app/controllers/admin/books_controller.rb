class Admin::BooksController < AdminController
  before_action :find_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to admin_books_path, :notice => 'Book created'
    else
      render :actin => :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to admin_books_path, :notice => 'Book updated!'
    else
      render :actin => :new
    end
  end

  def destroy
    @book.destroy
    redirect_to admin_books_path, :notice => 'Book deleted!'
  end

  private
    def find_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:name, :book_type, :parts_number)
    end
end
