class FollowsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @followers = current_user.followers
    @followees = current_user.followees
  end
end
