
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

  def update_time
    @posts = Post.all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("posts_list", partial: "posts/posts", locals: { posts: @posts })
      end
      format.html { redirect_to posts_path } # fallback
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
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path }
      end
    else
      flash[:alert] = "Your like did not work"
      redirect_back fallback_location: root_path
    end
  end

  def dislike
    current_user.likes.find_by(post: @post)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def createcomment
    @comment = Comment.new(
      user: current_user,
      post: @post,
      content: params[:content],
      parent_id: params[:parent_id]
    )

    if @comment.save
      Rails.logger.debug ">>>>>> Format: #{request.format}"
      puts "--------------------------------------------------------------------------------------------#{request.format}"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Comment added successfully" }
      end
    else
      Rails.logger.debug ">>>>>> Format: #{request.format}"
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Failed to add comment" }
      end
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
