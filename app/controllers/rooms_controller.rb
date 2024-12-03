class RoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room)
  end

 def show
  @room = Room.find(params[:id])
  @rooms = Room.all
  if Entry.where(user_id: current_user.id, room_id: @room.id).present?
    @messages = @room.messages
    @message = Message.new
    @entries = @room.entries
    @myUserId = current_user.id
  else
    redirect_back(fallback_location: root_path)
  end
 end


 private
    def reject_non_related
      room = Room.find_by(id: params[:id])
      if room.nil?
        redirect_to books_path, alert: "ルームが見つかりません"
      else
        user = room.entries.where.not(user_id: current_user.id).first.user
        unless current_user.following?(user) && user.following?(current_user)
          redirect_to books_path
        end
      end
    end


end
