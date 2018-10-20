class LikesController < ApplicationController
  def create
    @book = Book.find_or_initialize_by(isbn: params[:book_isbn])
    
    unless @book.persisted?
      results = RakutenWebService::Books::Book.search(isbn: @book.isbn)
      @book = Book.new(read(results.first))
      @book.save
    end
    
    current_user.like(@book)
    flash[:success] = "本をお気に入りに登録しました"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @book = Book.find(params[:book_id])
    current_user.unlike(@book)
    flash[:success] = "本のお気に入り登録を解除しました"
    redirect_back(fallback_location: root_path)
  end
end
