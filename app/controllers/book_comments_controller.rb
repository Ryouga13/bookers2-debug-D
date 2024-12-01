class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    book_comment = BookComment.new(comment_params)
    book_comment.user_id = current_user.id
    book_comment.book_id = book.id
    book_comment.save
    redirect_to book_path(book.id)
  end

  def destroy
    book_comment = BookComment.find(params[:id])
    book_comment.destroy
    redirect_to book_path(params[:book_id])
  end

  private
  def comment_params
    params.require(:book_comment).permit(:comment)
  end

end
