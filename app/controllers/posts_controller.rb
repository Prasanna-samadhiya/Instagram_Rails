
class PostsController < ApplicationController
  before_action :setpost, only: [ :show, :like, :dislike, :createcomment ]

  def create
    @post = Post.new(post_params)

    if params[:post][:image].present?
      @post.image.attach(params[:post][:image])
    end

    if @post.save
      redirect_to root_path, notice: "Post created successfully"
    else
      redirect_to root_path, alert: "Post creation failed"
    end
  end

  def show
  end

  def new
      @post = Post.new

      if request.xhr?
        render layout: false
      end
  end


  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user),  notice: "Post deleted successfully"
  end

  def like
    like = Like.new(user: current_user, post: @post)

    if like.save
      redirect_back fallback_location: root_path
    else
      flash[:alert] = "Your like did not work"
      redirect_back fallback_location: root_path
    end
  end

  def dislike
    like = current_user.likes.find_by(post: @post)
    like&.destroy

    redirect_back fallback_location: root_path
  end

  def createcomment
    content = params[:content]
    parent_id = params[:parent_id]

    comment = Comment.new(
      user: current_user,
      post: @post,
      content: content,
      parent_id: parent_id
    )

    if comment.save
      redirect_back fallback_location: root_path, notice: "Comment added successfully"
    else
      redirect_back fallback_location: root_path, alert: "Failed to add comment"
    end
  end

  def deletecomment
    comment = current_user.comments.find_by(id: params[:comment_id], post_id: params[:id])
    comment&.destroy

    redirect_back fallback_location: root_path, notice: "COmment deleted successfully"
  end

  private

  def setpost
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, :user_id)
  end
end
