class FriendshipsController < ApplicationController
  before_action :find_friend, only: %i[create destroy]

  def create
    @friendship = current_user.friendships.create(friend_id: @friend.id)
    if @friendship.save
      flash[:notice] = 'Request sent!'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = 'Something went wrong'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    @friendship = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    if @friendship.first.update_attributes(confirmed: true)
      flash[:notice] = 'Friend accepted!'
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = 'Something went wrong'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
  	if @friendship = (Friendship.where(user_id: params[:id], friend_id: current_user.id).first)
  		@friendship.destroy
  	elsif @friendship = (Friendship.where(user_id: current_user.id, friend_id: params[:id]).first)
  		@friendship.destroy
  	end
  	redirect_back(fallback_location: root_path)
  end

  private

  def find_friend
    @friend = User.find(params[:id])
  end
end
