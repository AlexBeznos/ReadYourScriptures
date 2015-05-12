class Admin::BookCategoriesController < AdminController
  before_action :find_book_category, only: [:show, :edit, :update, :destroy]

  def index
    @book_categories = BookCategory.page(params[:page]).per(10)
  end

  def new
    @book_category = BookCategory.new
  end

  def create
    @book_category = BookCategory.new(book_category_params)
    if @book_category.save
      redirect_to admin_book_categories_path, :notice => 'Book category created!'
    else
      render :actin => :new
    end
  end

  def edit
  end

  def update
    if @book_category.update(book_category_params)
      redirect_to admin_book_categories_path, :notice => 'Book category updated!'
    else
      render :actin => :new
    end
  end

  def destroy
    @book_category.destroy
    redirect_to admin_book_categories_path, :notice => 'Book category deleted!'
  end

  private
    def find_book_category
      @book_category = BookCategory.find(params[:id])
    end

    def book_category_params
      params.require(:book_category).permit(:name)
    end
end
