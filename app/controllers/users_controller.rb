class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu| 
        @userEntry.each do |u| 
          if cu.room_id == u.room_id 
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week


  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end


  def posts_on_date
    # リクエストの中からユーザーIDを取得し、データベースからユーザー情報を取得
    user = User.includes(:books).find(params[:user_id])
    # リクエストの中から指定された日付を取得し、日付オブジェクトに変換
    date = Date.parse(params[:created_at])
    # ユーザーが指定した日に投稿した本（books）をデータベースから検索
    @books = user.books.where(created_at: date.all_day)
    # 検索結果を表示するためのビュー（posts_on_date_form）にデータを送る
    render :posts_on_date_form
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  
end
