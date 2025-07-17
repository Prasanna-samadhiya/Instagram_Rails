class HomeController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    if current_user
      @users = current_user.followers
    end

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def show
  end
end
