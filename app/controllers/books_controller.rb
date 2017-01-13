class BooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_book, only: [:show, :edit, :update, :destroy]

  def index

    if user_signed_in? && params[:ft] && params[:ft]=='my'
      @books = Book.includes(:bookmarks, :reviews, :user).where(user_id: current_user.id).order('updated_at DESC')
      @opt1 = 'my'
    elsif user_signed_in? && params[:ft] && params[:ft]=='bookmark'
      @books = Book.joins(:bookmarks).where('bookmarks.user_id = ?', current_user.id).order('updated_at DESC')
      @opt1 = 'bookmark'
    else
      @books = Book.includes(:bookmarks, :reviews, :user).order('updated_at DESC')
      @opt1 = 'all'
    end

    if params[:ct].present?
      @books = @books.joins(:categories).where('category_id = ?',params[:ct])
      @category = Category.find(params[:ct])
      @opt2 = params[:ct]
    end
    @categories = Category.all

  end

  def show
    if user_signed_in?
      @my_bookmark = @book.bookmarks.select{|s| s.user_id == current_user.id}.first
    end

    if user_signed_in?
      my_review = @book.reviews.select{|s| s.user_id == current_user.id}.first
      unless my_review
        @my_review = Review.new
      end
    end
  end
  
  def new
    @book = Book.new
    @categories = Category.all
  end

  def create
    @book = Book.new
    @book.attributes = input_params
    @book.user_id = current_user.id

    if @book.valid?
      @book.save!
      flash[:notice] = I18n.t('book.created')
      redirect_to action: :show, id: @book.id
    else
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    @book.attributes = input_params
    @book.user_id = current_user.id
    if @book.valid?
      @book.save!
      flash[:notice] = I18n.t('book.updated')
      redirect_to action: :show
    else
      render :edit
    end
  end

  def destroy
    @book.destroy!
    flash[:notice] = I18n.t('book.deleted')
    redirect_to action: :index
    
  end

private
  def input_params
    params.require(:book).permit(:title, :author, :publisher, :price, :publish_date, :caption, :image, {:category_ids=>[]})
  end
  def find_book
    @book = Book.find(params[:id])
  end
end
