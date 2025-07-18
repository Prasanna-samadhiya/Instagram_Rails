class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(content: params[:comment][:content])
    redirect_back fallback_location: root_path
  end

  def reply
    @parent_comment = Comment.find(params[:id])
    @post = @parent_comment.post

    @reply = Comment.new(
      user: current_user,
      post: @post,
      content: params[:reply_text],
      parent_id: @parent_comment.id
    )

    if @reply.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(
            "replies_for_comment_#{@parent_comment.id}",
            partial: "comments/comment",
            locals: { comment: @reply }
          )
        }
        format.html { redirect_back fallback_location: root_path, notice: "Reply added" }
      end
    else
      redirect_back fallback_location: root_path, alert: "Reply failed"
    end
  end
end
